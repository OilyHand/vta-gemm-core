import numpy as np

a = np.arange(0, 256, 1, dtype=np.uint8)

print(a)
print(a.shape)


b = a.reshape((1, 1, 16, 16))

print(b)
print(b.shape)

c = a.reshape((1, 1, 16, 16)).transpose((0,2,1,3))
print(c)
print(c.shape)