# list in python
# we can store elements of different types(integer, float, string etc.)
#marks = [94.4, 87.5, 95.2, 66.5]
#print(marks)
#print(type(marks))
#print(len(marks))
#print(marks[1])

#student = ["karan", 96, "Delhi"]

#print(student[-0:-2 ])

# strings are immutable in python and list are mutable in python.
#student[0] = "Arjun"
#print(student[0])

#str4 = "Kalpesh"
#print(str4[1:4])
#print(str4[:4])
#print(str4.replace("a", "p3"))

# list method
#list = [2, 1, 3]
#list.append(4) # add one element at the end
#list.sort() # sorts in ascending order
#list.sort(reverse=True) # reverse list [4,3,2,1]
#list.reverse() # revese list [4,3,2,1]
#list.insert(0,5) # 5 will inserted on index [0]
#list.insert(1,10) # 10 will be inserted on position 1
#list.pop(2) # remove elment which was there in postion of [2] index
#list.remove(1) # remove element of 1 from the entire list
#list.insert(4,5) # inserted 5 on index[4]
#print(list)

# tupels- a built in data types that lets us create immutable sequenceces of value.
#str = ("kalesh")
#print(type(str)) # will show string class

#list = [2, 4,8]
#print(type(list)) # will show list class

tup = (2,4,8,4)
#print(type(tup)) # will show typle class

#print(tup[0])
#tup[0] = 5 # will not allow to chnage value in tuple as string.
#tup = ("2",) # if we put value then (,) mean this would be treated as a tuple as it would trated as integer. 
#print(tup[0:1]) # slicing

# tuple method
#print(tup.index(4)) # retuns index of first occurance 
#print(tup.count(4)) # count total occurances, it would show as 4 has come 2 times.

# Write a code to ask the user to enter names of three 3 movies and store in list
#movies = []
#mov1= input("Enter First movie name: ")
#mov2= input("Enter Second movie name: ")
#mov3= input("Enter Third movie name: ")

#movies.append(mov1)
#movies.append(mov2)
#movies.append(mov3)

#print(movies)

#movies = []
#mov  = input("Enter First movie Name: ")
#movies.append(mov)
#mov  = input("Enter Second movie Name: ")
#movies.append(mov)
#mov  = input("Enter Third movie Name: ")
#movies.append(mov)

#print(movies)

# WAP to ask if a list contains a palindrome of elements(hint use copy() method)

#list1 = [1, 2, 1]
#list2 = [1, 2, 3]
#copy_list1 = list1.copy()
#copy_list1.reverse()

#if(copy_list1 == list1):
#    print("palindrom")
#else:
#    print("Not Palindrom")

#WAP to count the number of student with the "A" grade in the following tuple.
#["C", "D", "A", "B", "A", "B", "A"]


#grade = ("C", "D", "A", "B", "A", "B", "A")
#print(grade.count("A"))

# Store the above value in a list and sort them from "A" to "D"
#grade = ["C", "D", "A", "B", "A", "B", "A"]
#grade.sort()

#print(grade)