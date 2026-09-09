
#nums = (1,4,9,16,25,36,49,64,81,100)
#x = 81
#i = 0

#while i < len(nums):
#    if(nums[i] == x):
#        print("Found at idx", i)
#        break
#    else:
#        print("finding ..")
#        i += 1

#        print("End of loop")

#i = 1
#while i <=5:
#    print(i)
#    if(i ==3):
#        break
#    i +=1

#i = 1
#while i <=7:
#    if(i%2 ==0):
#        i +=1
#        continue
#    print(i)
#    i +=1

# for loop 
#nums = [1,2,3,4,5, "kalpesh", 0.2]
#for val in nums:
#    print(val)

#Sum of numbers from 1 to 100

#total = 0
#for i in range(1,101):
#    total +=i
#    print("sum:", total)

# Find the largest number in a list
#numbers = [10,5,90,89]
#smallest = numbers[0] # initlize the smallest number
#for num in numbers:
#    if num < smallest:
#        smallest = num

#print("Smallest:", smallest)
# count vovels in a string
#text = "python is awesome"
#count = 0
#for ch in text.lower():
#    if ch in "aeiou":
#        count +=1
#print("Vowels:", count)

text = "Hell"
count = 0

for ch in text: 
    if ch in ('a', 'e', 'i', 'o', 'u', 'A', 'E','I', 'O', 'U'):
        count +=1



print(count)
