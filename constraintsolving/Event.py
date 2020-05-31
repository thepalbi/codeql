class Event:
    def __init__(self, id, reps=None):
        if reps is None:
            reps = list()
        self.id = id
        self.reps = reps

    def add_rep(self, rep):
        self.reps.append(rep)

