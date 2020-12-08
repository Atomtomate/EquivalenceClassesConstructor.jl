---
slug: "/EquivalenceClasses/Introduction"
date: "2020-11-12"
title: "Equivalence Classes Introduction"
categories: ["Programming", "Julia", "Memoization"]
---

# Introduction

In this project we want to construct a tool that can exploit symmetries of objects and function calls with one or more indices, in order to reduce the number of times this call needs to be evaluated.
The most common implementation of this concept, would be a [memoization](https://en.wikipedia.org/wiki/Memoization) code, that dynamically checks for repeated calls, only passing back references on repeated calls with *identical* arguments.
This means, that a cache is dynamically build during the runtime of a program and function calls are wrapped in order to first check for previous calls with the same arguments.
The notion of identical calls can be generalized by the formulation some **equivalency relation** $R(x,y)$ over the argument space $\mathcal{A}$ and $x,y \in \mathcal{A}$.
If we have access to the explicit form of this equivalency relation, we can formulate a static version of the memoization algorithm, overcoming the necessity of a cache and repeated evaluations of $R(x,y)$.

Instead of dynamically checking every call, we start out by building a list of unique indices over a given domain $\mathcal{D} \subset \mathcal{A}$.
The equivalency relation $R$ segments the set $\mathcal{D}$ into $c$ equivalency classes.
We can now pass on a list $\mathcal{D}_\text{red}$ of $c$ indices, each of them being a representative of an equivalence class, to the main code.
Additionally we also provide a mapping $\text{Expand}(\mathcal{D}_\text{red})$, returning lists of equivalent indices for each of the $c$ representatives.
The code can now operate on $\mathcal{D}_\text{red}$ instead of $\mathcal{D}$, later expanding the solution to the full space by using $\mathcal{D}_\text{expand}$

While supporting a completely dynamic structure through memoization is arguably more flexible, our static approach has two advantages
  - Better performance: we have a 0-cycle overhead on function calls and storage, operating only on a minimal set of indices.
  - Better understanding of the equivalency classes: By generating the full equivalence structure we may achieve additional insight into the symmetries of the evaluated function.


## Example

Let us consider a simple example of the considerations above. 
Consider the function $f(x) = x^2$ and a domain $\mathcal{D} = \{-3,-2.9, \cdots 7.9, 8\}$. We can exploit the symmetry $f(-x) = f(x)$ by defining 

```R(x,y) = (x == -y) || (-x == y) || (x == y)```.

Note, that we explicitly force *Reflexivity* and *Symmetry*, since we will only evaluate over a finite domain.
We expect our program to return $c = 80$ equivalency classes, containing for example $\mathcal{D}_\text{red} = \{0, \cdots 7.9, 8\}$.
Furthermore, we expect $\text{Expand}(0) = \{\}, \text{Expand}(0.1) = \{-0.1\}, \cdots \text{Expand}(3) = \{-3\}, \text{Expand}(3.1) = \{\}, \cdots$
Remember, that the index domain for our numerical applications will in general be $\mathbb{Q}^N$ with $N > 1$.


## Generalizations

One can consider dynamical implementationsof this approach by switching to an *online* algorithm for the segmentation into connected components [[1]](#1).


# Code Structure

We will expect the input of our code to be some equivalency relation $R$ and a domain $\mathcal{D}$ of indices. 
The code will build a undirected graph $\mathcal{G}(V,E)$ with $V = \mathcal{D}$ and $E = \{R(x,y) | x,y \in V\}$.
Every [connected component](https://en.wikipedia.org/wiki/Component_(graph_theory)) of this graph is one equivalency class and we can pick any representative $c_i$ of this class to be in $\mathcal{D}_\text{red}$.
All remaining nodes of the component need to be mapped by $\text{Expand}(c_i)$.
There are [multiple options](https://en.wikipedia.org/wiki/Component_(graph_theory)#Algorithms) for obtaining all connected components of a graph.
Our default will be depth first search.

- 2-Arity Predicates
- Data structure for graph
- Algorthims on graph

# Datastructures
- Explain all structs

# Mappings

## Problems
Non monotonic behavior, i.e. mappings that lead out of the set but iteration eventually leads back, can not be detected.
This is a general statement, since detection of such a behavior is undecidable (equivalent to the halting problem).


# References
<a id="1">[1]</a> 
Yossi Shiloach and Shimon Even. 1981.
An On-Line Edge-Deletion Problem. *J. ACM* 28, 1 (Jan. 1981), 1–4. DOI: https://doi.org/10.1145/322234.322235
