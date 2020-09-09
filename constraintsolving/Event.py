from typing import List


class Event:
    def __init__(self, id, reps=None):
        if reps is None:
            reps = list()
        self.id = id
        self.reps: List[str] = reps

    def add_rep(self, rep):
        self.reps.append(rep)
