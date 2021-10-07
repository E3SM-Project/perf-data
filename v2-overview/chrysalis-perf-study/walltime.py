import math, sys

tfactor = int(sys.argv[1])
nodecount = int(sys.argv[2])

minutes = math.ceil(tfactor*20*85.0/nodecount)
hours = math.floor(minutes/60)
minutes = minutes - 60*hours
walltime = '{:02d}:{:02d}:00'.format(hours, minutes)

print(walltime)
