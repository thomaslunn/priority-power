Priority Power
===========

Adds power transformers for connecting power networks, for designating generators as priority or reserve power.

Transformers, available at Logistics science, are used to prioritise or deprioritise power from sections of your factory. Place the transformer bridging the gap between two power networks, such that the two ends of the entity are each in one of the two networks. The transformer will pull energy from the input network and provide it to the output network - tooltips will show which end of the entity is which. The behaviour of the transformer can be controlled in its UI. Example use cases are as follows:

- *Backup power* - _input Secondary, output Tertiary_ - provides excess power to the output network when its own power supply runs low
- *Burning byproducts for power* - _input Tertiary, output Primary_ - energy generated in the input network will be utilised with highest priority in the output network
- *Priority to power production* - _input Primary, output Secondary_ - ensure the output network is always provided sufficient power when available, e.g. mining drills for coal
- *Overflow production* - _input Tertiary, output Secondary_ - overflow any excess power not needed elsewhere in the network for storage or for low-priority production

Known issues
-------------
- In some configurations, a chain of transformers forming a loop will infinitely send power between themselves, causing infinitely increasing power production graphs and infinite energy storage.

With thanks to:
---------------
[semantic-release-factorio](https://github.com/fgardt/semantic-release-factorio) - Tool used for automated mod publishing
[Electric Transformators](https://mods.factorio.com/mod/Electric_Transformators) - Inspiration and assets. This mod could be considered a spiritual successor for Factorio 2.0

