/**
 * Provides classes and predicates used by the XSS queries.
 */

import javascript

/** Provides classes and predicates shared between the XSS queries. */
module SharedWorse {
  /** A data flow source for XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overriden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    string getVulnerabilityKind() { result = "Cross-site scripting" }
  }

  /** A sanitizer for XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  class MetacharEscapeSanitizer extends Sanitizer, DataFlow::MethodCallNode {
    MetacharEscapeSanitizer() {
      getMethodName() = "replace" and
      exists(RegExpConstant c |
        c.getLiteral() = getArgument(0).asExpr() and
        c.getValue().regexpMatch("['\"&<>]")
      )
    }
  }
}

/** Provides classes and predicates for the DOM-based XSS query. */
module DomBasedXssWorse {
  /** A data flow source for DOM-based XSS vulnerabilities. */
  abstract class Source extends SharedWorse::Source { }

  /** A data flow sink for DOM-based XSS vulnerabilities. */
  abstract class Sink extends SharedWorse::Sink { }

  /** A sanitizer for DOM-based XSS vulnerabilities. */
  abstract class Sanitizer extends SharedWorse::Sanitizer { }

  /**
   * An expression whose value is interpreted as HTML
   * and may be inserted into the DOM through a library.
   */
  class LibrarySink extends Sink, DataFlow::ValueNode {
    LibrarySink() {
      // call to a jQuery method that interprets its argument as HTML
      exists(JQueryMethodCall call | call.interpretsArgumentAsHtml(astNode) |
        // either the argument is always interpreted as HTML
        not call.interpretsArgumentAsSelector(astNode)
        or
        // or it doesn't start with something other than `<`, and so at least
        // _may_ be interpreted as HTML
        not exists(DataFlow::Node prefix, string strval |
          isPrefixOfJQueryHtmlString(astNode, prefix) and
          strval = prefix.asExpr().getStringValue() and
          not strval.regexpMatch("\\s*<.*")
        ) and
        not isDocumentURL(astNode)
      )
      or
      // call to an Angular method that interprets its argument as HTML
      any(AngularJS::AngularJSCall call).interpretsArgumentAsHtml(this.asExpr())
      or
      // call to a WinJS function that interprets its argument as HTML
      exists(DataFlow::MethodCallNode mcn, string m |
        m = "setInnerHTMLUnsafe" or m = "setOuterHTMLUnsafe"
      |
        mcn.getMethodName() = m and
        this = mcn.getArgument(1)
      )
    }
  }

  /**
   * Holds if `prefix` is a prefix of `htmlString`, which may be intepreted as
   * HTML by a jQuery method.
   */
  private predicate isPrefixOfJQueryHtmlString(Expr htmlString, DataFlow::Node prefix) {
    any(JQueryMethodCall call).interpretsArgumentAsHtml(htmlString) and
    prefix = htmlString.flow()
    or
    exists(DataFlow::Node pred | isPrefixOfJQueryHtmlString(htmlString, pred) |
      prefix = StringConcatenation::getFirstOperand(pred)
      or
      prefix = pred.getAPredecessor()
    )
  }

  /**
   * An expression whose value is interpreted as HTML or CSS
   * and may be inserted into the DOM.
   */
  class DomSink extends Sink {
    DomSink() {
      // Call to a DOM function that inserts its argument into the DOM
      any(DomMethodCallExpr call).interpretsArgumentsAsHTML(this.asExpr())
      or
      // Assignment to a dangerous DOM property
      exists(DomPropWriteNode pw |
        pw.interpretsValueAsHTML() and
        this = DataFlow::valueNode(pw.getRhs())
      )
      or
      // `html` or `source.html` properties of React Native `WebView`
      exists(ReactNative::WebViewElement webView, DataFlow::SourceNode source |
        source = webView or
        source = webView.getAPropertyWrite("source").getRhs().getALocalSource()
      |
        this = source.getAPropertyWrite("html").getRhs()
      )
    }
  }

  /**
   * An expression whose value is interpreted as HTML by a DOMParser.
   */
  class DomParserSink extends Sink {
    DomParserSink() {
      exists(DataFlow::GlobalVarRefNode domParser |
        domParser.getName() = "DOMParser" and
        this = domParser.getAnInstantiation().getAMethodCall("parseFromString").getArgument(0)
      )
    }
  }

  /**
   * A React `dangerouslySetInnerHTML` attribute, viewed as an XSS sink.
   *
   * Any write to the `__html` property of an object assigned to this attribute
   * is considered an XSS sink.
   */
  class DangerouslySetInnerHtmlSink extends Sink, DataFlow::ValueNode {
    DangerouslySetInnerHtmlSink() {
      exists(DataFlow::Node danger, DataFlow::SourceNode valueSrc |
        exists(JSXAttribute attr |
          attr.getName() = "dangerouslySetInnerHTML" and
          attr.getValue() = danger.asExpr()
        )
        or
        exists(ReactElementDefinition def, DataFlow::ObjectLiteralNode props |
          props.flowsTo(def.getProps()) and
          props.hasPropertyWrite("dangerouslySetInnerHTML", danger)
        )
      |
        valueSrc.flowsTo(danger) and
        valueSrc.hasPropertyWrite("__html", this)
      )
    }
  }

  /**
   * The HTML body of an email, viewed as an XSS sink.
   */
  class EmailHtmlBodySink extends Sink {
    EmailHtmlBodySink() { this = any(EmailSender sender).getHtmlBody() }

    override string getVulnerabilityKind() { result = "HTML injection" }
  }

  /**
   * A write to the `template` option of a Vue instance, viewed as an XSS sink.
   */
  class VueTemplateSink extends DomBasedXssWorse::Sink {
    VueTemplateSink() { this = any(Vue::Instance i).getTemplate() }
  }

  /**
   * The tag name argument to the `createElement` parameter of the
   * `render` method of a Vue instance, viewed as an XSS sink.
   */
  class VueCreateElementSink extends DomBasedXssWorse::Sink {
    VueCreateElementSink() {
      exists(Vue::Instance i, DataFlow::FunctionNode f |
        f.flowsTo(i.getRender()) and
        this = f.getParameter(0).getACall().getArgument(0)
      )
    }
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, SharedWorse::MetacharEscapeSanitizer { }
}

/** Provides classes and predicates for the reflected XSS query. */
module ReflectedXssWorse {
  /** A data flow source for reflected XSS vulnerabilities. */
  abstract class Source extends SharedWorse::Source { }

  /** A data flow sink for reflected XSS vulnerabilities. */
  abstract class Sink extends SharedWorse::Sink { }

  /** A sanitizer for reflected XSS vulnerabilities. */
  abstract class Sanitizer extends SharedWorse::Sanitizer { }

  /**
   * An expression that is sent as part of an HTTP response, considered as an XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  private class HttpResponseSink extends Sink {
    HttpResponseSink() {
      exists(HTTP::ResponseSendArgument sendarg | sendarg = asExpr() |
        forall(HTTP::HeaderDefinition hd |
          hd = sendarg.getRouteHandler().getAResponseHeader("content-type")
        |
          exists(string tp | hd.defines("content-type", tp) | tp.toLowerCase().matches("%html%"))
        )
      )
    }
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, SharedWorse::MetacharEscapeSanitizer { }
}

/** Provides classes and predicates for the stored XSS query. */
module StoredXssWorse {
  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends SharedWorse::Source { }

  /** A data flow sink for stored XSS vulnerabilities. */
  abstract class Sink extends SharedWorse::Sink { }

  /** A sanitizer for stored XSS vulnerabilities. */
  abstract class Sanitizer extends SharedWorse::Sanitizer { }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink { AnySink() { this instanceof SharedWorse::Sink } }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, SharedWorse::MetacharEscapeSanitizer { }
}
