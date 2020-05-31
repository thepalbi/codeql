from Event import Event

class FlowRelation:
    def __init__(self, source: Event, sanitizer: Event, sink: Event):
        self.source = source
        self.sanitizer = sanitizer
        self.sink = sink



