#String concatanation
#str1= "kalpesh"
#str2= "patel"
#final_str = str1 + " " + str2
#print(final_str)
#print(len(final_str))

# Indexing

#str = "Kalpesh Patel"
#ch = str[2]
#print(ch)

# Slicing
#str4 = "Ahmedabad" # string value
#print(str4[0:3]) # it mean, we want to get value from 0 to 3.
#print(str4[2:]) # it mean, we want to get value from 2 to last value of string.
#print(str4[4: len(str4)]) # it mean, we want to get value from 4 to last
#print(str4[ :4]) # it mean, we want to get value from 0 to 4.

# Slicing = Negative index
#str4 = "kalpesh"
#print(str4[-7: -1])

# String function
#str = "I am a coder from India"
#print(str.endswith("er")) # will get output "true"
#print(str.startswith("I")) # will get output "true"
#print(str.startswith("i")) # will get output "false", as we have input small i and actul syntex started from caps "I"
# upercase function
#str = str.capitalize()
#print(str)# lowercase function
#str = str.lower()
#print(str)

#print(str.replace("o", "l"))  # o replace with L
#print(str.replace("I", "W"))  # I replace with W
#print(str.replace("am", "was")) # whole string replace from am to was
#print(str.find("a")) # find the charcher which start from a in whole string with index value
#print(str.find("m"))

# Q- WAP to input user's first name & print its length
#va1 = input("What is your name: ")
#print(va1)
#print(len(va1))

# Q- WAP to find the occurrance of '$' in a string
#str = " hi i $am the $ symbol"

#print(str.find("$")) # will show the index
# 
# Conditional statements
# if-elif-else (syntex)
#age = 18
#if (age>= 18):
#    print("Can we vote")
#    print("Can drive")

#light = "green"
#if(light=="red"):
#    print("stop")
#elif(light=="green"):
#    print("go")
#elif(light=="yellow"):
#    print("wait")

# else condition
#light = "green"
#if(light=="red"):
#    print("stop")
#elif(light=="green" ):
#    print("go")
#elif(light=="yellow"):
#    print("wait")
#else:
#    print("ligh is broken") 

#age = 17
#if(age>= 18):
#    print("Can vole")
#else:
#    print("cannot vote")

#marks= int(input("Enter Student Marks: "))
#if (marks>=90):
#  grade="A"
#elif(marks>=80 and marks < 90):
#  grade = "B" 
#elif(marks>=70 and marks<80):
#  grade = "C"
#elif(marks>=60 and marks<70):
#  grade = "D"
#else:
#  grade = "D"

#print("Grade of Student->", grade)

# nesting= write statement inside one statement
#age = int(input("Enter your Age: "))
#if age>=18:
#    if(age>=80):
#     print("Cannot drive")
#    else:
#     print("can drive")
#else:
#    print("cannot dirve")
#num = int(input("Enter number: "))
#if(num %2 ==0):
#    print("Even")
#else:
#    print("ODD")

#a = int(input("Enter first number: "))
#b = int(input("Enter Second number: "))
#c = int(input("Enter Third number: "))

#if(a>=b and a>=c):
#    print("first number is largest", a)
#elif(b>=c):
#    print("Second number is largest", b)
#else:
#    print("third is largest", c)

#x = int(input("Enter Number: "))
#if(x % 7==0):
#    print("multiple of 7")
#else:
#    print("Not multiple of 7")
