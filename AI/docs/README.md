Understanding RAG System – QA Portal Use Case
![Uploading image.png…]()

 

To understand the RAG (Retrieval-Augmented Generation) system, I went through the following use case.
1. Use Case Overview
Consider a QA form portal where users can ask questions, and other users who have knowledge about the topic can provide answers.
Over time, a large amount of Question and Answer (Q&A) data is generated through this portal.
The organization plans to implement a RAG-based system so that users can ask questions and receive relevant answers based on the existing knowledge stored in the system.
________________________________________
2. Data Storage
The questions and answers submitted through the QA portal are stored in a PostgreSQL database.
Periodically, this data is transferred from PostgreSQL to Snowflake for further processing and analysis.
Other knowledge sources, such as:
•	README.md files
•	Documentation
•	Application-related information
•	Other relevant text-based content
can also be stored in Snowflake.
Therefore, Snowflake becomes a centralized location for the data that will be used by the RAG system.
________________________________________
3. Data Chunking
The next step is to divide the raw data into smaller pieces called chunks.
This process can be implemented using Python.
For example, instead of processing an entire document or a very large answer as one piece of information, the content is divided into smaller, meaningful sections.
Each chunk is assigned a unique Chunk ID.
An important feature of chunking is that adjacent chunks can have some overlapping content.
For example:
Chunk 1:
"The dog is a domestic animal. Dogs are commonly kept as pets..."

Chunk 2:
"Dogs are commonly kept as pets. They can be trained to..."

Chunk 3:
"They can be trained to perform various tasks..."
The overlap helps preserve the relationship between the previous and next sections and reduces the possibility of losing context when the data is divided into chunks.
The processed chunks can then be stored in dedicated tables in Snowflake.
________________________________________
4. Vector Embeddings
After chunking, the next step is to generate vector embeddings for each chunk.
A vector embedding converts text into a numerical representation that captures the semantic meaning of the text.
For example:
"This is a dog."
        ↓
Embedding Model
        ↓
[0.12, -0.45, 0.78, 0.21, ...]
The exact numbers are not important to the user. What matters is that semantically similar pieces of text have embeddings that are relatively close to each other in vector space.
The generated embeddings are stored along with the corresponding chunks and Chunk IDs.
________________________________________
5. User Query and Similarity Search
When a user asks a question, the question is also converted into a vector embedding using the same or compatible embedding model.
For example, suppose the user asks:
"Is this a dog or a cat?"
The system converts this question into a vector and performs a similarity search against the stored vectors.
If the system is configured to retrieve the top 5 results, it will identify the five chunks whose vector representations are most similar to the user's question.
Conceptually:
User Question
     ↓
Generate Query Embedding
     ↓
Vector Similarity Search
     ↓
Retrieve Top 5 Relevant Chunks
     ↓
Use Retrieved Chunks as Context
The retrieved chunks provide the relevant context required for generating the final answer.
________________________________________
6. LLM and Context
Once the relevant context has been retrieved, the system sends the following information to an LLM (Large Language Model):
•	User's original question
•	Relevant chunks retrieved from the vector search
•	Appropriate instructions/prompt
For example:
Context:
[Retrieved relevant information from the QA system]

Question:
"Is this a dog or a cat?"

Instruction:
"Answer the question based on the provided context."
Python can be used to implement this backend workflow and integrate the required LLM modules/models, such as Claude Sonnet.
The LLM uses the provided context along with the user's question to generate an answer.
________________________________________
7. Overall RAG Flow
The complete flow can be summarized as follows:
QA Portal
   ↓
Questions & Answers
   ↓
PostgreSQL
   ↓
Periodic Data Transfer
   ↓
Snowflake
   ↓
Data Chunking using Python
   ↓
Generate Chunk IDs
   ↓
Generate Vector Embeddings
   ↓
Store Chunks + Embeddings
   ↓
────────────────────────────
       User asks a question
────────────────────────────
   ↓
Generate Query Embedding
   ↓
Vector Similarity Search
   ↓
Retrieve Top-K Relevant Chunks
   ↓
Build Prompt with Context
   ↓
LLM (e.g., Claude Sonnet)
   ↓
Generate Context-Based Answer
8. Key Understanding
The main purpose of RAG is to provide the LLM with relevant information from an organization's own data before generating an answer.
Instead of relying only on the information learned during the LLM's training, the RAG system retrieves relevant information from the organization's knowledge base and provides it as context to the LLM.
In this use case:
PostgreSQL → Snowflake → Chunking → Embeddings → Vector Search → Context → LLM → Answer
The quality of the final answer depends on several factors, including:
•	Quality of the source data
•	Chunking strategy
•	Embedding model
•	Similarity-search configuration
•	Number of retrieved chunks (Top-K)
•	Quality of the prompt
•	LLM's ability to interpret the provided context
Therefore, RAG can be considered a combination of information retrieval + contextual data + LLM-based generation.

