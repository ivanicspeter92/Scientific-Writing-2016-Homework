Exercise 1
----------
Given a string `babacccabac`:

* states for the first-order Markov-chain: ['a', 'b', 'c']
* second-order Markov-chain: ['ba', 'cc', 'ac']
* transition probabilities for the first-order Markov-chain: 
    * 'b' -> 'a' = 1.0
    * 'a' -> 'b' = 0.5
    * 'a' -> 'c' = 0.5
    * 'c' -> 'c' = 0.66
    * 'c' -> 'a' = 0.33
    
Exercise 7
----------
Person/Producer:
* The creative agent in this case is the piece of software, which has the knowledge on the usage of Markov chains, their attributes, upsides and limitations.
* The system could be extended with for instance an evaluation component, which could utilize reinforcement learning where supervisors (programmers) of the system would evaluate gradually the performance of certain steps. By involving a human party and its evaluation, the system could adjust its parameters and improve its strategy over time.

Process:
* The system in this case utilizes Markov chains and probability calculations based on the given input to generate its product.
* The system could be extended in a way that the tokenization of the text can be done in multiple ways (e.g. by combining multiple data sources, looking up similar text on the Internet), various ways of combining the tokens is tried out (e.g. generating various orders the Markov chains randomly or according to some algorithm)

Product:
* The product of this system is the new text, which is generated from the original using Markov chains
* A possible extension is to add more textual resources and their value measures to which the system can compare its new products as part of the evaluation

Press/Environment:
* The environment is very much dependent on what kind of text is on the input of the system. Depending on the genre or the domain of the input text, the system's environment is selected similarly (i.e. if the input is a set of technical documents, the system environment will be related to technical documents accordingly).
* The environment can be extended by providing a wider variety of input text that tell about multiple topics and domains.
