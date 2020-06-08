class Variable:
    def __init__(self, id, is_constant=False, value=0):
        self.id = id
        self.is_constant=is_constant
        self.value = value

    def set_constant(self, value):
        self.is_constant = True
        self.value = value

    def print(self):
        if self.is_constant:
            return "{0}:constant:{1}".format(self.id, self.value)
        else:
            return "{0}:variable".format(self.id)
