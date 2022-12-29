# DWH Section

## Material

We will use these pages for this section:

1. [Dimensions section](./01-DWH-Concepts-Dimensions.md)

2. [Facts section](./02-DWH-Facts.md)

## Agenda

- The Four Steps
  - Select business process
  - Select the grain
  - Select dimensions
  - Select facts


  > Tiempo: 10 min . Para esta sección mostraré el modelo relacional y abriré debate sobre cada paso

>

- Dimension types
  - Surrogate key vs Natural Key
  > Tiempo 5 min. Crear la misma dimensión `customer` con ambos tipos de llaves. 
  - Date and time dimension como Role-Playing Dimension

  > Tiempo: 5 min. Crear las dos dimensiones y hablar de las bondades y casos de uso. 
  - Degenerated dimension
  > Tiempo: 5 min.  No tengo ejemplo en el modelo. porque rental y payment 1:1. Simular que tengo más de un `rental` por `payment`
  - Junk Dimension vs Centipede Dimension

  > Tiempo: 5 min Utilizar `category`, `language` y `film`
  - Conformed Dimension
  > Tiempo: 5 min Pensar en el caso de redes sociales y cómo `customer` sería nuestra conformed
  - Slow Changing Dimensions
  > Tiempo 15 min: Usar `inventory` para mostrar SCD Tipo 1 y 2

- Fact tables
  - Fact Tables Types
    - Transactional
    - Periodic Snapshot
    - Accumulating snapshots
  > Tiempo 10 min: 
  > Transactional: rental_id
  > Periodic: Rentas por mes.
  > Accumulating: Suponer estados
  - Measure type
    - Additive
    - Semi additive
    - Non Additive
  > Tiempo: 10 min Additive: suma de rentas (transactional)
  > Semi Additive: balance de cuentas por mes (periodic snapshot)
  > Non additive: Ratio de inventory por mes
  - Surrogate key?
  > Tiempo 3 min. Caso teórico
  
  - Data Modelling in Big Data
    - Data Modelling vs Dimensional Modelling
    - Columnar Storage vs Row Storage
    - HDFS - Worker nodes
  > Tiempo 10 min. Casos teóricos. Poner imágenes para representar
  

- Modern DWH (New Techniques??)
   - Denormalized Data Structures
     - Why denormalize?
     - Denormalization techniques
     - Advantages and disadvantages of denormalization
   - Nested Repeated Fields
  > Tiempo 10 min. Examples

- Cloud DataWarehouse Architectures
    - Top 5 Architectures in market (tools, diferences, how to choose?)
  > Tiempo 5 min.
