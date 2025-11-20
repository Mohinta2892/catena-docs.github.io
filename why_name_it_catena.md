# The story behind the name CATENA

Firstly, I should clarify that CATENA is **not** an acronym. So CATENA can be written as Catena or catena.

The story behind naming this package is actually very simple and maybe a little silly.

When I ventured into connectomics after two years of working on Magnetic Resonance Imaging at the Queen Square Institute of Neurology, UCL, UK, I was quite stunned by the fragmented software ecosystem in the connectomics world. There were so many good tools, algorithms, and packages, but most were niche. However, a connectome, to me, meant not only that the core neurons and synapses were identified so that a connectivity matrix or a graph could be built, but also that we had other features identified such as cell-types, neurotransmitters at synaptic locations, and even mitochondria.

Existing software did all of these things, but never under one umbrella. Different groups optimized different parts, which meant that one had to first find which was the best model to do a given task and then learn its software dependencies. A common problem was also that many of these software packages were old and unmaintained; what you may have read in the paper could no longer be reproduced in code.

All of this led me to believe that I could create a package that, while very much standing on the shoulders of giants, gives users (connectome mappers) a one-stop link where they can explore different aspects of both mapping a core connectome and enriching the same connectome with further information. I wanted to bind or `chain` the popular tools (and even invent a few of my own) under one hood that I would later call Catena. 

Catena also literally means a chain of connected ideas or objects.

