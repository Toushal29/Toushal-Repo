import random as r
import time
guess = []
start_time = time.perf_counter()
coordinates = (r.randint(0,100), r.randint(0,100), r.randint(0,100))
x = r.randint(0,100)
y = r.randint(0,100)
z = r.randint(0,100)
guesses = 0
while x != coordinates[0]:
    if x > coordinates[0]:
        x -= 1
        guesses += 1
    else:
        x += 1
        guesses += 1
while y != coordinates[1]:
    if y > coordinates[1]:
        y -= 1
        guesses += 1
    else:
        y += 1
        guesses += 1
while z != coordinates[2]:
    if z > coordinates[2]:
        z -= 1
        guesses += 1
    else:
        z += 1
        guesses += 1
guess.append(guesses)
end_time = time.perf_counter()
runtime = end_time - start_time
print(guess)
sum = 0
for a in guess:
    sum += a
print(sum/len(guess))
print(f"Execution time: {runtime:.6f} seconds")