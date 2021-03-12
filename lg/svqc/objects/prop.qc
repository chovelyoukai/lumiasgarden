void setPropModel()
{
    setModel(self, self.modelPath);
}

void prop()
{
    precache_model(self.modelPath);
    self.think = setPropModel;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_NONE;
    setSize(self, self.minSize, self.maxSize);
}
