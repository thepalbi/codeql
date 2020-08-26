import javascript

module TsmRepr {
    float getReprScore(string repr, string t){
    repr = "(parameter 0 (return (member prepend *)))" and t = "snk" and result = 1.0  or 
    repr = "(member dumy (member FWDRLUtils (global)))" and t = "snk" and result = 1.0  or 
    repr = "(member hostname *)" and t = "san" and result = 0.073475148275784  or 
    repr = "(return (member toArray *))" and t = "src" and result = 0.08499999999999999  or 
    repr = "(member url *)" and t = "san" and result = 0.541125541125541  or 
    repr = "(parameter 1 (return (member replace *)))" and t = "src" and result = 0.26190476190476186  or 
    repr = "(member $slides (instance (member SliderPro (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (member main_do *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member id (parameter 1 (instance (member constructor *)))))" and t = "san" and result = 0.8504280588583331  or 
    repr = "(member element *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter nodeName *)" and t = "src" and result = 0.12878787878787876  or 
    repr = "(member content (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(member _lastFocusedEl (member instance (member magnificPopup (parameter $ *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slide (instance (member SliderProSlide (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member currentTarget *)" and t = "snk" and result = 1.0  or 
    repr = "(member $slides (instance (member SliderPro (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(member image *)" and t = "src" and result = 0.25999999999999995  or 
    repr = "(return (member call (parameter b *)))" and t = "snk" and result = 0.16071428571428548  or 
    repr = "(member hitThhumbnailId_to (instance (member FWDUGPThumbnail (parameter t *))))" and t = "san" and result = 0.7860708538961039  or 
    repr = "(member $imageContainer (instance (member SliderProSlide *)))" and t = "snk" and result = 1.0  or 
    repr = "(member options *)" and t = "san" and result = 1.0  or 
    repr = "(member secondTapId_to *)" and t = "san" and result = 1.0  or 
    repr = "(member $slider (instance (member SliderPro (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $item (member image *))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (return (member append *))))" and t = "snk" and result = 1.0  or 
    repr = "(member getElementsByClassName *)" and t = "san" and result = 0.45740151515151517  or 
    repr = "(member target (member event (global)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter index *)" and t = "src" and result = 0.75  or 
    repr = "(member buttons (member elem (parameter 1 (return (member bind *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member buttons (member elem *))" and t = "snk" and result = 1.0  or 
    repr = "(member thumbHeight *)" and t = "src" and result = 0.024458874458874458  or 
    repr = "(member scs_el (instance (member FWDUGPData (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member parseInt (global))))" and t = "src" and result = 0.13449151654796818  or 
    repr = "(member opt *)" and t = "src" and result = 0.2813852813852814  or 
    repr = "(parameter 0 (return (member jQuery *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member Boolean (global)))" and t = "san" and result = 0.2595155709342554  or 
    repr = "(parameter 0 (return (parameter 0 (root https://www.npmjs.com/package/magnific-popup))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member call *)))" and t = "snk" and result = 0.17999999999999997  or 
    repr = "(member $menu (instance (member constructor (member prototype (member Constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesMask (instance (member SliderPro (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter index (parameter 0 (return (member each *))))" and t = "src" and result = 1.0  or 
    repr = "(member target (member event (member responsiveBaseWidth (member options (member owlCarousel *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member innerHTML (return (member createElement (member document (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member jQuery (global)))" and t = "san" and result = 0.7142857142857141  or 
    repr = "(member screen (instance (member FWDConsole (global))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member insertBefore (member parentNode *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter data *)" and t = "src" and result = 0.009999999999999953  or 
    repr = "(member $item *)" and t = "snk" and result = 1.0  or 
    repr = "(member target (member event (member responsiveBaseWidth (member options *))))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el (instance (member FWDRL (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(member _lastFocusedEl (member instance (member magnificPopup (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 1.0  or 
    repr = "(member msRequestFullscreen *)" and t = "src" and result = 0.5882352941176469  or 
    repr = "(parameter 0 (return (member selector (member constructor (member prototype *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $newElement (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member userAgent (member navigator (global)))" and t = "snk" and result = 1.0  or 
    repr = "(member $slide (instance (member SliderProSlide (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesContainer *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member clearTimeout (global))))" and t = "snk" and result = 0.3461772142857142  or 
    repr = "(parameter 0 (member load *))" and t = "src" and result = 0.6547619047619049  or 
    repr = "(member content (member instance (member magnificPopup (parameter $ (root https://www.npmjs.com/package/magnific-popup)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter url *)" and t = "src" and result = 0.6309523809523809  or 
    repr = "(parameter el *)" and t = "src" and result = 0.47096964285714293  or 
    repr = "(member screen (member main_do (instance (member FWDRL (parameter window *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member createElement (member document (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member el *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (return (parameter _dereq_ *))))" and t = "snk" and result = 0.38387857142857174  or 
    repr = "(member bullets (member elem *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member data (return (member parent *))))" and t = "src" and result = 0.2777099567099568  or 
    repr = "(member $newElement *)" and t = "snk" and result = 1.0  or 
    repr = "(member content (member instance *))" and t = "snk" and result = 1.0  or 
    repr = "(member target (parameter e (parameter 2 (return (member on *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member String (global)))" and t = "san" and result = 0.21435182056741736  or 
    repr = "(member target (member event (member responsiveBaseWidth *)))" and t = "snk" and result = 1.0  or 
    repr = "(member hasPointerEvent (member FWDRLUtils *))" and t = "san" and result = 0.5106271794313747  or 
    repr = "(return (member getElementById *))" and t = "src" and result = 0.2739125412610248  or 
    repr = "(member b *)" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesContainer (instance (member SliderPro (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member getTransform *))" and t = "src" and result = 0.5  or 
    repr = "(member scs_el (instance (member FWDUGPData (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member 1 (return (member exec *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (parameter _dereq_ *))" and t = "src" and result = 0.2761214285714284  or 
    repr = "(parameter elems *)" and t = "src" and result = 0.1497093711949165  or 
    repr = "(member $slides (instance (member SliderPro *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member text *))" and t = "src" and result = 0.4540207267479995  or 
    repr = "(member $slidesMask (instance (member SliderPro (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member after *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter a *)" and t = "src" and result = 0.3214285714285714  or 
    repr = "(member 0 (return (member slice *)))" and t = "snk" and result = 0.24999999999999983  or 
    repr = "(member _lastFocusedEl (return (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesMask (instance (member SliderPro (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (parameter e *))" and t = "snk" and result = 1.0  or 
    repr = "(member $container *)" and t = "snk" and result = 1.0  or 
    repr = "(member src (return (member createElement *)))" and t = "src" and result = 0.13999999999999968  or 
    repr = "(parameter html *)" and t = "src" and result = 0.25  or 
    repr = "(parameter 0 (member screen *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member apply *))" and t = "src" and result = 0.1275  or 
    repr = "(member secondTapId_to (instance (member FWDRLEVPlayer *)))" and t = "san" and result = 1.0  or 
    repr = "(member elements *)" and t = "src" and result = 0.14285714285714285  or 
    repr = "(return (member createElement (member target *)))" and t = "san" and result = 1.0  or 
    repr = "(member _lastFocusedEl (member instance (member magnificPopup *)))" and t = "snk" and result = 1.0  or 
    repr = "(member body *)" and t = "snk" and result = 1.0  or 
    repr = "(member _lastFocusedEl (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (parameter b *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (member data *))" and t = "snk" and result = 0.007575757575757569  or 
    repr = "(parameter 0 (member target *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (return (parameter _dereq_ *))))" and t = "san" and result = 0.342458089500861  or 
    repr = "(member $slide (instance (member SliderProSlide *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member replace *))" and t = "san" and result = 0.11904761904761907  or 
    repr = "(parameter image *)" and t = "src" and result = 0.607142857142857  or 
    repr = "(member $thumbnailsContainer *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter e *)" and t = "src" and result = 0.35304970344843206  or 
    repr = "(member hasHTML5Video (member FWDRLEVPlayer *))" and t = "src" and result = 0.47058823529411703  or 
    repr = "(member $newElement (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $clipStyles (instance (member constructor (member jarallax (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member html (return (parameter $ *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member walk *)))" and t = "snk" and result = 0.3500168491023975  or 
    repr = "(member $newElement (instance (member Constructor (member selectpicker *))))" and t = "snk" and result = 1.0  or 
    repr = "(member mfpEl *)" and t = "snk" and result = 1.0  or 
    repr = "(member paginationWrapper *)" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesMask (instance (member SliderPro *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member attr *))" and t = "san" and result = 0.5580607142857141  or 
    repr = "(member data *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member insertBefore (member documentElement (member document *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member bullets (member elem (parameter 1 (return (member bind *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member innerHTML (member screen *))" and t = "snk" and result = 1.0  or 
    repr = "(member buttonNext *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member jQuery (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (member instance (member magnificPopup (parameter $ *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (instance (member constructor (member prototype *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $menu (instance (member Constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDRLConsole *)))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (member instance *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (parameter b *)))" and t = "san" and result = 0.020854529034420765  or 
    repr = "(return (member round (member Math (global))))" and t = "src" and result = 0.6161214285714283  or 
    repr = "(member context *)" and t = "snk" and result = 1.0  or 
    repr = "(member target (member event (member window (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member $newElement (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member extend (parameter $ *)))" and t = "san" and result = 0.8079741379310345  or 
    repr = "(parameter 0 (return (member $ (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesMask *)" and t = "snk" and result = 1.0  or 
    repr = "(member $lis *)" and t = "snk" and result = 1.0  or 
    repr = "(member $menu (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (member main_do (instance (member FWDRL *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slidesContainer (instance (member SliderPro (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member append *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member css *))" and t = "san" and result = 0.28362568674042354  or 
    repr = "(member scs_el (member target *))" and t = "snk" and result = 1.0  or 
    repr = "(member target (parameter 0 (parameter 2 (return (member on *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member exec *))" and t = "san" and result = 0.25  or 
    repr = "(member $arrows *)" and t = "snk" and result = 1.0  or 
    repr = "(member screen (parameter e (member addChild *)))" and t = "snk" and result = 1.0  or 
    repr = "(member content (member mfp (global)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member selector *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild (return (member id *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member thumbnailsContainerSize *)" and t = "san" and result = 0.3736971861471858  or 
    repr = "(return (member concat *))" and t = "san" and result = 0.5597093711949166  or 
    repr = "(parameter 2 (return (member style (member $ *))))" and t = "snk" and result = 0.19779129011617042  or 
    repr = "(parameter 0 (return (member insertBefore (member documentElement *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $thumbnailArrows *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (return (member apply *)))" and t = "snk" and result = 0.31043290043290045  or 
    repr = "(member dumy *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendTo (return (member find *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member createElement *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member parent (return (parameter $ *))))" and t = "san" and result = 1.0  or 
    repr = "(parameter root *)" and t = "src" and result = 0.5  or 
    repr = "(return (member slice *))" and t = "san" and result = 0.08859940689686417  or 
    repr = "(member $slider (instance (member SliderPro *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member concat *)))" and t = "src" and result = 0.3097093711949166  or 
    repr = "(return (member split (member 1 (return (member split *)))))" and t = "san" and result = 0.75  or 
    repr = "(member dumy (member FWDRLUtils (member window (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen *)" and t = "snk" and result = 1.0  or 
    repr = "(member responseText *)" and t = "snk" and result = 0.015151515151515138  or 
    repr = "(member content (return (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter div *)" and t = "src" and result = 0.2875  or 
    repr = "(member href *)" and t = "src" and result = 0.706099406896864  or 
    repr = "(return (member getChildren *))" and t = "san" and result = 1.0  or 
    repr = "(member target (parameter a *))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (member 0 (member children_ar *)))" and t = "snk" and result = 1.0  or 
    repr = "(member $thumbnails *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member wrapAll *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member match (member userAgent *)))" and t = "src" and result = 0.0357142857142857  or 
    repr = "(member target (member originalEvent *))" and t = "snk" and result = 1.0  or 
    repr = "(parameter element *)" and t = "src" and result = 0.607142857142857  or 
    repr = "(return (member min *))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (return (root https://www.npmjs.com/package/jquery)))" and t = "snk" and result = 1.0  or 
    repr = "(member isIphone (member FWDRLUtils (global)))" and t = "src" and result = 0.5  or 
    repr = "(parameter 0 (return (member appendTo *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member trim (parameter $ *)))" and t = "san" and result = 0.45605627705627694  or 
    repr = "(return (member data *))" and t = "src" and result = 0.2813852813852814  or 
    repr = "(member contentContainer (return (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member cloneNode *))" and t = "san" and result = 0.2761214285714284  or 
    repr = "(return (member getBannerClone *))" and t = "san" and result = 0.11958859897386209  or 
    repr = "(member length *)" and t = "src" and result = 0.5  or 
    repr = "(member target (member originalEvent (parameter event *)))" and t = "snk" and result = 1.0  or 
    repr = "(member body (member document (global)))" and t = "snk" and result = 1.0  or 
    repr = "(member $lis (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member buttonPrev *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (return (member forEach *))))" and t = "src" and result = 0.05224285714285681  or 
    repr = "(member content (return (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member buttons *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter str *)" and t = "src" and result = 0.5075757575757576  or 
    repr = "(member content (member instance (member magnificPopup (parameter 0 (root https://www.npmjs.com/package/magnific-popup)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (return (member appendChild *))))" and t = "snk" and result = 1.0  or 
    repr = "(member content (member instance (member magnificPopup (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 1.0  or 
    repr = "(member $iframe (instance (member VideoWorker (global))))" and t = "san" and result = 0.47058823529411736  or 
    repr = "(parameter 0 (return (member getChildren *)))" and t = "src" and result = 0.7060994068968641  or 
    repr = "(member target (parameter 0 (member _onThumbnailTouchEnd *)))" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el (instance (member FWDRL (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild (member stageContainer *))))" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el (instance (member FWDUGPData *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member test *)))" and t = "src" and result = 0.7575757575757576  or 
    repr = "(parameter 0 (return (member createElement (member document *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member replace (return (member css *))))" and t = "san" and result = 0.43473809523809503  or 
    repr = "(parameter 0 (return (member appendTo (return (member jQuery *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member setTimeout (global))))" and t = "src" and result = 0.2067693331044866  or 
    repr = "(member content (member instance (member magnificPopup (parameter $ *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member append (return (parameter $ *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member content (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member $menu (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member keys (member Object (global))))" and t = "src" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild (member screen *))))" and t = "snk" and result = 1.0  or 
    repr = "(member _lastFocusedEl (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member prependTo *)))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (member instance (member magnificPopup (root https://www.npmjs.com/package/jquery))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member write (member document (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member write *)))" and t = "snk" and result = 1.0  or 
    repr = "(member testShoutCastId_to (instance (member FWDRLEAPAudioScreen (global))))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (return (member append (return (member empty *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member write (member document *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member find (member $thumbnails *)))" and t = "src" and result = 1.0  or 
    repr = "(member value *)" and t = "san" and result = 0.25  or 
    repr = "(member target (member event *))" and t = "snk" and result = 1.0  or 
    repr = "(member instance *)" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDRLConsole (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member testShoutCastId_to (instance (member FWDRLEAPAudioScreen (parameter e *))))" and t = "san" and result = 1.0  or 
    repr = "(return (member toLowerCase *))" and t = "san" and result = 0.08749999999999991  or 
    repr = "(parameter s *)" and t = "src" and result = 0.2963940984718094  or 
    repr = "(parameter 0 (return (member selector (return (member _class *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member target (parameter event (member _onThumbnailTouchEnd *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member magnificPopup *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member split *))" and t = "san" and result = 0.39285714285714285  or 
    repr = "(member innerHTML (return (member createElement *)))" and t = "snk" and result = 1.0  or 
    repr = "(member push *)" and t = "snk" and result = 0.016975885246976033  or 
    repr = "(parameter 0 (return (member appendTo (return (parameter $ *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member hasPointerEvent (member FWDRLUtils (parameter e *)))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (return (member parse *)))" and t = "src" and result = 0.30355503082775803  or 
    repr = "(parameter 0 (return (member append (member wrap *))))" and t = "snk" and result = 1.0  or 
    repr = "(member stageHeight *)" and t = "src" and result = 0.02455097141641611  or 
    repr = "(parameter 0 (member el *))" and t = "snk" and result = 1.0  or 
    repr = "(member dumy (member FWDRLUtils *))" and t = "snk" and result = 1.0  or 
    repr = "(return (member appendTo *))" and t = "san" and result = 1.0  or 
    repr = "(parameter 1 (return (member call *)))" and t = "snk" and result = 0.41071428571428553  or 
    repr = "(parameter 0 (member init *))" and t = "src" and result = 0.9372500000000001  or 
    repr = "(parameter 0 (return (member get *)))" and t = "snk" and result = 0.12676365800865796  or 
    repr = "(member $clipStyles (instance (member constructor (member jarallax *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $newElement (instance (member constructor (member prototype (member Constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member elem *)" and t = "snk" and result = 1.0  or 
    repr = "(member target (parameter e *))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 2 (return (member attr *)))" and t = "snk" and result = 0.017642857142857182  or 
    repr = "(parameter elem *)" and t = "src" and result = 0.10694826516663702  or 
    repr = "(member $slide *)" and t = "snk" and result = 1.0  or 
    repr = "(member bullets *)" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDRLConsole (parameter e *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (member document (global))))" and t = "san" and result = 0.9098524617952328  or 
    repr = "(member $container (member image (instance (member constructor *))))" and t = "snk" and result = 1.0  or 
    repr = "(member $imageContainer (instance (member SliderProSlide (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $lis (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (parameter 0 (return (return (parameter _dereq_ *)))))" and t = "src" and result = 0.6935714285714287  or 
    repr = "(member screen (parameter 0 (member addChild *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (parameter $ *))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild (member documentElement *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member ceil (member Math (global))))" and t = "src" and result = 0.09346777967633799  or 
    repr = "(return (member width *))" and t = "src" and result = 0.4066401428571427  or 
    repr = "(member $imageContainer (instance (member SliderProSlide (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(member delay *)" and t = "san" and result = 0.0714285714285714  or 
    repr = "(member $menu (instance (member Constructor (member selectpicker (member fn *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member innerHTML *)" and t = "snk" and result = 1.0  or 
    repr = "(member $newElement (instance (member Constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el (instance (member FWDRL *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (parameter $ (parameter 0 (return (member ready *)))))" and t = "san" and result = 0.18391709300800207  or 
    repr = "(member scs_el (instance (member FWDUGPData (global))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member html (return (member find *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member exec *)))" and t = "snk" and result = 0.01354970344843209  or 
    repr = "(member screen (member main_do (instance (member FWDRL (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member insertBefore *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member parent (return (member jQuery (global)))))" and t = "san" and result = 0.46103896103896064  or 
    repr = "(return (member find (return (parameter _dereq_ *))))" and t = "san" and result = 0.19357142857142867  or 
    repr = "(return (member jQuery (member window (global))))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (return (member each *))))" and t = "src" and result = 0.25  or 
    repr = "(return (member createElement (member target (parameter event *))))" and t = "san" and result = 1.0  or 
    repr = "(member $menu (instance (member Constructor (member selectpicker *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter context *)" and t = "src" and result = 0.4196428571428572  or 
    repr = "(return (member getChildren (member FWDRLUtils (global))))" and t = "san" and result = 0.20609940689686412  or 
    repr = "(parameter 0 (return (member push *)))" and t = "san" and result = 0.5  or 
    repr = "(parameter 0 (return (member $ *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member getComputedStyle (global)))" and t = "src" and result = 0.25  or 
    repr = "(return (member createTextNode *))" and t = "san" and result = 0.25757575757575746  or 
    repr = "(member target (member event (parameter window *)))" and t = "snk" and result = 1.0  or 
    repr = "(member s *)" and t = "src" and result = 0.06989408577269891  or 
    repr = "(parameter 0 (return (parameter $ *)))" and t = "snk" and result = 1.0  or 
    repr = "(member $slider (instance (member SliderPro (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member dropdown *)" and t = "src" and result = 0.4761904761904762  or 
    repr = "(parameter 0 (return (member appendTo (return (member parent *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member label *)" and t = "src" and result = 0.2238785714285716  or 
    repr = "(parameter b *)" and t = "src" and result = 0.36529905335628216  or 
    repr = "(return (member call *))" and t = "san" and result = 0.75  or 
    repr = "(member secondTapId_to (instance (member FWDRLEVPlayer (member window (global)))))" and t = "san" and result = 1.0  or 
    repr = "(member testShoutCastId_to (instance (member FWDRLEAPAudioScreen (member window (global)))))" and t = "san" and result = 0.9080244663865539  or 
    repr = "(parameter c *)" and t = "src" and result = 0.49999999999999994  or 
    repr = "(return (member match *))" and t = "src" and result = 0.7142857142857143  or 
    repr = "(return (parameter b *))" and t = "san" and result = 0.5219502965515679  or 
    repr = "(parameter 0 (parameter 0 (return (member jQuery (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slider (instance (member SliderPro (parameter window *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member killTweensOf (member FWDRLTweenMax (global)))))" and t = "snk" and result = 0.3222208354682924  or 
    repr = "(member contentContainer (return (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild (return (member createElement *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member appendTo (return (member jQuery (global)))))" and t = "src" and result = 1.0  or 
    repr = "(member target (parameter event *))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member jQuery (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(member slideHeight *)" and t = "src" and result = 0.32497736285714307  or 
    repr = "(member contentContainer (instance (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDConsole (parameter e *))))" and t = "snk" and result = 1.0  or 
    repr = "(member target *)" and t = "snk" and result = 1.0  or 
    repr = "(member hasExtraText_bl *)" and t = "san" and result = 0.3566058576371728  or 
    repr = "(member $slider *)" and t = "snk" and result = 1.0  or 
    repr = "(member secondTapId_to (member keyboardCurInstance (member FWDRLEVPlayer (global))))" and t = "san" and result = 1.0  or 
    repr = "(return (member createElement (member context *)))" and t = "san" and result = 1.0  or 
    repr = "(return (member keys *))" and t = "src" and result = 0.1605000000000001  or 
    repr = "(member $clipStyles (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(member $menu (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member appendChild *)))" and t = "snk" and result = 1.0  or 
    repr = "(member _lastFocusedEl *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member replaceWith *)))" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (member instance (member magnificPopup *)))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (parameter 0 (member addChildAt *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter i *)" and t = "src" and result = 0.2238785714285716  or 
    repr = "(member $clipStyles (instance (member constructor (member jarallax (parameter window *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (member target (member type (parameter event *)))))" and t = "san" and result = 1.0  or 
    repr = "(member container *)" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement *))" and t = "san" and result = 0.6052990533562822  or 
    repr = "(return (member $ (global)))" and t = "san" and result = 0.25  or 
    repr = "(member content (return (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $slides *)" and t = "snk" and result = 1.0  or 
    repr = "(member dumy (member FWDRLUtils (parameter e *)))" and t = "snk" and result = 1.0  or 
    repr = "(return (member setTimeout (global)))" and t = "san" and result = 0.4533200714285713  or 
    repr = "(member $elem *)" and t = "snk" and result = 1.0  or 
    repr = "(member engine *)" and t = "san" and result = 0.857142857142857  or 
    repr = "(member $slidesContainer (instance (member SliderPro *)))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDConsole (member window (global)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (member target (member triggered *))))" and t = "san" and result = 0.8947009466437147  or 
    repr = "(return (member Number (global)))" and t = "san" and result = 0.12213095238095228  or 
    repr = "(return (member css (return (parameter $ *))))" and t = "san" and result = 0.2792207792207791  or 
    repr = "(member $slide (instance (member SliderProSlide (global))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member join *))" and t = "san" and result = 0.33025000000000004  or 
    repr = "(parameter idx *)" and t = "src" and result = 0.0803571428571428  or 
    repr = "(member subtitles *)" and t = "src" and result = 0.2238785714285716  or 
    repr = "(parameter 0 (member get *))" and t = "src" and result = 1.0  or 
    repr = "(member $thumbnailContainer *)" and t = "snk" and result = 1.0  or 
    repr = "(member html *)" and t = "snk" and result = 1.0  or 
    repr = "(member $container (member image *))" and t = "snk" and result = 1.0  or 
    repr = "(member 1 (return (member split *)))" and t = "src" and result = 0.3214285714285714  or 
    repr = "(member isIOS *)" and t = "src" and result = 0.25  or 
    repr = "(return (member parseInt (global)))" and t = "san" and result = 0.2742606662328031  or 
    repr = "(member hasHTML5Video (member FWDRLEVPlayer (global)))" and t = "src" and result = 1.0  or 
    repr = "(member content (member instance (member magnificPopup *)))" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member html *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter t *)" and t = "src" and result = 0.35304970344843206  or 
    repr = "(parameter 0 (return (parameter $ (root https://www.npmjs.com/package/magnific-popup))))" and t = "snk" and result = 1.0  or 
    repr = "(member preloader *)" and t = "snk" and result = 1.0  or 
    repr = "(return (member closest *))" and t = "src" and result = 0.24999999999999997  or 
    repr = "(member $slidesContainer (instance (member SliderPro (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDRLConsole (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member $clipStyles (instance (member constructor (member jarallax (member fn *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member content *)" and t = "snk" and result = 1.0  or 
    repr = "(member screen (member main_do (member target *)))" and t = "snk" and result = 1.0  or 
    repr = "(member content (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter h *)" and t = "src" and result = 0.30806071428571413  or 
    repr = "(member contentContainer *)" and t = "snk" and result = 1.0  or 
    repr = "(member contentContainer (return (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter video *)" and t = "src" and result = 0.607142857142857  or 
    repr = "(member captionContent *)" and t = "snk" and result = 1.0  or 
    repr = "(return (member _getEl (global)))" and t = "san" and result = 0.11574074074074073  or 
    repr = "(member userAgent *)" and t = "snk" and result = 1.0  or 
    repr = "(member $slides (instance (member SliderPro (global))))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (parameter e (member addChildAt *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member html (member $captionContainer *))))" and t = "snk" and result = 1.0  or 
    repr = "(member player (instance (member VideoWorker *)))" and t = "san" and result = 0.8875605326876512  or 
    repr = "(parameter t (parameter 1 (return (member _class *))))" and t = "src" and result = 0.17516219937483002  or 
    repr = "(member vars *)" and t = "src" and result = 0.23786966688359845  or 
    repr = "(member $iframe (instance (member VideoWorker (member window (global)))))" and t = "src" and result = 0.5799031476997579  or 
    repr = "(member $clipStyles *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member insertAfter *)))" and t = "snk" and result = 1.0  or 
    repr = "(member type *)" and t = "snk" and result = 1.0  or 
    repr = "(return (member encodeURI (global)))" and t = "san" and result = 0.23214285714285715  or 
    repr = "(member $menu *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter root (parameter 0 (return (return (parameter _dereq_ *)))))" and t = "src" and result = 1.0  or 
    repr = "(member secondTapId_to (member keyboardCurInstance *))" and t = "san" and result = 1.0  or 
    repr = "(member selectedThumbnailIndex *)" and t = "src" and result = 1.0  or 
    repr = "(return (member createElement (member common (return (parameter _dereq_ *)))))" and t = "san" and result = 1.0  or 
    repr = "(parameter 0 (parameter 0 (instance (member constructor *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (member player *))" and t = "src" and result = 0.3550242130750605  or 
    repr = "(member secondTapId_to (instance (member FWDRLEVPlayer (global))))" and t = "san" and result = 0.1022354841269854  or 
    repr = "(member lastChild *)" and t = "snk" and result = 1.0  or 
    repr = "(member scs_el (instance (member FWDRL (global))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member map *))" and t = "san" and result = 0.2238785714285716  or 
    repr = "(member timer *)" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (return (parameter $ *)))" and t = "snk" and result = 0.02338095238095228  or 
    repr = "(member $lis (instance (member constructor *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member selector (member constructor *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter n *)" and t = "src" and result = 0.3097093711949166  or 
    repr = "(parameter 0 (return (parameter e *)))" and t = "snk" and result = 1.0  or 
    repr = "(member screen (instance (member FWDConsole *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter structure *)" and t = "src" and result = 0.5  or 
    repr = "(parameter 0 (return (member insertAfter (return (parameter $ *)))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (return (member find (return (parameter _dereq_ *)))))" and t = "snk" and result = 0.6082571428571433  or 
    repr = "(member $imageContainer (instance (member SliderProSlide (global))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member jQuery *))" and t = "san" and result = 0.26376398916271815  or 
    repr = "(member _lastFocusedEl (member instance *))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (member init *))" and t = "src" and result = 0.16045892857142874  or 
    repr = "(parameter 1 (return (member proxy *)))" and t = "snk" and result = 0.05347413258331851  or 
    repr = "(parameter 0 (return (member insertBefore (member screen *))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member replace (return (member replace *))))" and t = "san" and result = 0.701952380952381  or 
    repr = "(member $buttons *)" and t = "snk" and result = 1.0  or 
    repr = "(return (member createElement (member common *)))" and t = "san" and result = 0.5273252052647981  or 
    repr = "(parameter 1 (return (member extend (member jQuery (global)))))" and t = "src" and result = 0.14547413793103436  or 
    repr = "(member $container (member image (instance (member constructor (member jarallax *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member description *)" and t = "snk" and result = 1.0  or 
    repr = "(return (parameter a *))" and t = "san" and result = 0.1428571428571428  or 
    repr = "(member $imageContainer *)" and t = "snk" and result = 1.0  or 
    repr = "(member innerHTML (return (member id *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 1 (return (member setAttribute *)))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member Number (global))))" and t = "snk" and result = 0.10610346966672601  or 
    repr = "(member src (return (member createElement (member document (global)))))" and t = "src" and result = 0.8600000000000003  or 
    repr = "(member _delay *)" and t = "san" and result = 0.8536083813862446  or 
    repr = "(parameter 2 (return (member createElement (return (parameter _dereq_ *)))))" and t = "src" and result = 0.4477571428571432  or 
    repr = "(parameter 0 (return (member isFinite (global))))" and t = "snk" and result = 0.14938860094596934  or 
    repr = "(member _lastFocusedEl (instance (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member replace (parameter text *)))" and t = "san" and result = 0.6941515151515151  or 
    repr = "(member _lastFocusedEl (return (member constructor (member prototype *))))" and t = "snk" and result = 1.0  or 
    repr = "(member old (return (member speed (member $ *))))" and t = "snk" and result = 0.06313131313131307  or 
    repr = "(member _lastFocusedEl (return (member constructor (member prototype (member constructor *)))))" and t = "snk" and result = 1.0  or 
    repr = "(member $newElement (instance (member Constructor (member selectpicker (member fn *)))))" and t = "snk" and result = 1.0  or 
    repr = "(return (member find *))" and t = "san" and result = 0.8064285714285713  or 
    repr = "(parameter 0 (return (member appendChild (member body *))))" and t = "snk" and result = 1.0  or 
    repr = "(parameter 0 (return (member clearTimeout *)))" and t = "snk" and result = 0.007575757575757569
    }
}