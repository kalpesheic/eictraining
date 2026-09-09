# Dictionary 
# dictionary are used to store data value in key:value pair
# They are unordered, mutable(chanagble) and don't allow duplicate value



#info = {
#    "Name" : "kalpesh",
#    "subject" : ["python", "C", "java"],
#    "topics" : ("dict", "set"),
#    "age" : 35,
#    "is adult" : True,
#    12.99 : 94.4
#}

#print(info["is adult"])
#info["name"] = "Patel"
#print(info)
#info = {
#    "name" : "Kalpesh",
#    "cpg" : 9.0,
#     "Marks": [98, 69, 78],
#}

#info["name"], dict["cpg"], dict["Marks"]

#print(type(info))
#print(info["name"])
#print(info["Marks"])
#info ["name"] = "Rakesh"
#print(info)
# Nested dictronary
#student = {
#    "name": "kalpesh",
#    "subject" : {
#        "phy": 97,
#        "chy": 89,
#        "math": "90"
#    }
#}

#myDict.keys()-> retrun all keys
# myDict.values()-> returns all values
# myDict.items()-> retuns all(key,val) pairs as tuples
# myDict.get("key")-> retrun the key accroding to value
# myDict.update(newDict)-> inserts the items into dictionary
#  
#print(student)
#print(student["subject"])
#print(student["subject"]["phy"])
#print(len(list(student.keys())))
#print(len(student))
#print(list(student.values()))
#print(list(student.items()))
#pair = list(student.items())
#print(pair[1])
#student.update({"City": "Delhi", "Age": 20})

#print(student)

# Set in Python
# Set is the collection of the unordered items
# Each element in the set must be unique and immutable

#nums = {1, 2, 3, 4, "hello", "world", 4}
#set2 = {1,2, 2, 2}
#print(len(nums))

collection = set()
collection.add(1)
collection.add(2)
collection.add((1,2, 3)) # added tuble
#collection.add((1,2,3))
#print(type(collection))
print(collection)