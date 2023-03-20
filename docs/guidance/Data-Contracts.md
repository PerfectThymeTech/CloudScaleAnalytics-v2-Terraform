# Data Contracts

**Keywords:** Data Contracts, Data Mesh, Data Product, Data Consumer, Data Producer

## Introduction

Within modern and distributed Data Platforms like Data Mesh, datasets are no longer considered a byproduct that data application teams happen to create but are now understood as first-class citizens of a data platform that need to be managed as products themselves. These data products are supposed to be shareable assets that offer an SLA, are monitored, catalogued, and can be consumed by other data application teams to create additional value based on the existing datasets.

When data products are shared, there are always two parties involved: the data producer and the data consumer team. The data producer manages the to be shared data asset and grants reader access to the data consumer team to allow them to read the full or a subset of the data.

As the data platform as well as the number of data products within a data platform grows, the interface between data producers and data consumers becomes crucial for the success of the platform. The interface between the two needs to be clearly defined to make sure that dependencies are not breaking, and downstream consumers and applications are not affected.

In order to do so, we are introducing the concept of a Data Contract as a clearly defined abstraction and interface between a Data Producer and Data Consumer within a data platform. As part of the next paragraphs, the term Data Contracts will be defined, and a high-level architecture will be provided that illustrates the high-level functionality within a distributed data platform.

## Data Contract Definition

A Data Contract is an explicit and extendible definition of the interface between a data producer and a data consumer where a data product gets shared among the two parties in accordance with the definition of the contract.

Before understanding the implications of the data contract, we must first define and describe some of the underlying terms such as data product, data consumer and data producer and how they are related to each other.

![Data Contract Relationship Diagram](/docs/media/Data-Contract-Relationhsip-Diagram.png)

The centerpiece of data contracts are data products, which are owned by a data producer team, and which consist of one or multiple data assets. These data products are managed, as the term suggests, as products. This means that a data producer team produces and monitors these, manages the full lifecycle from ingestion to consumption, incorporates the feedback loop and provides a Service Level Agreement (SLA) for the datasets. A Data Producer team usually consists of different personas and can own one or multiple data products. These data products are then offered within a marketplace where data consumer teams that are part of the same or other organizations can request access to consume and reuse the data. Therefore, a data producer can share a data product with zero or many data consumers and data consumers can consume zero or many data products.

To make the data product as well as the data consumption more explicit and transparent, the data contract concept is introduced. The data contract “gives the event meaning and form beyond the context in which it is produced and extends the usability of the data to consumer applications” (cf. Bellamare (2020, ch. 3)). Therefore, Data Contracts promise to provide the following benefits:

1. Ensuring that the consumer of a message can accurately convey the content and meaning of the data product.
2. Provide data consumers with a clear understanding of what is consumed and how it can be consumed and ensure compliant consumption of data products.
3. Ensure compliance of data producers with data contract definitions to prevent critical changes with unforeseen impact on downstream consumers within the platform.
4. Clear visibility of consumers for a data provider.
5. Version and change management as well as possibility to deprecate product versions over time.

## High-level functionality

![Data Contract High-level Functionality](/docs/media/Data-Contract-High-Level-Functionality.png)

When publishing a data product, the data producer needs to publish a data contract to a data contract repository, which is a versioned library of all data contracts within an organization. A version of a data contract needs to be an immutable object to ensure that downstream consumers are not affected by changes. In addition, data contracts need to be enforced on the data producer side to further ensure that data consumption is not affected. For versioning, data producers should follow the semantic versioning model of v{major}.{minor}.{patch}, whereas it needs to be clearly defined what changes are considered as major or minor. It is important to note that compatibility (forward, backward or full compatibility) needs to be considered when choosing the version increment.

Once a data contract has been published, data consumers can access and consume the data product when accessing the provided data product produced by the data producer. The data contract will contain relevant metadata required for consuming the underlying data assets.

## Information captured in a Data Contract

![Coverage of a Data Contract](/docs/media/Data-Contract-High-Level-Functionality.png)

Data Contracts are extendible by nature and allow to capture additional metadata in form of key-value pairs specified by the data producer team. Still, there are a number of items that will always be part of a data contract. We propose to capture the following items as static objects of a data contract:

| Item          | Description                                |
| ------------- | ------------------------------------------ |
| Version       | Specifies the version of a data contract. Version numbers should follow the semantic versioning model (v{major}.{minor}.{patch}). A specific version of a contract is immutable and defines the properties of the underlying data assets as well as the data provider. Schema evolution is possible via versioning. |
| Owner         | Specifies the owner of the data product including name, email address and additional metadata. |
| Source System | Specifies the source system of the data assets. This is an Enum and can contain a pre-defined list of values. |
| Schema        | Specifies the explicit schema of the data assets. |
| File Format   | Specifies the file format in case the data asset is stored on an object store. |
| Metadata      | Specifies additional metadata published by the Data Producer team. |
| Deprecation   | Specifies when the version of the dataset will be deprecated. |
| Events        | Specifies where update events can be consumed. |
| Comments      | Comments can be used in multiple sections to provide human readable information to data consumers (e.g. fields in schema, events). |
