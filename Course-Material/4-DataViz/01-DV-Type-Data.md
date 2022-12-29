| [Previous](./DataViz_Index.md) | [Back to Agenda](./DataViz_Index.md)  | [Next](./02-DV-Encode-Data.md) |
| :---------|:----------:|---------: |

# Data Visualization Fundamentals | (1) Type of data

In this chapter, we will review:
- Categorical data: Nominal, Ordinal, Hierarchical
- Quantitative data: Discrete, Continuous

## Categorical data

  Categorical data represents **qualitative characteristics** like gender or language. It may be a numerical value without mathematical meaning. 
  
  Based on how it can be ordered, it can be classified as:
  - **Nominal**: **Labels** to distinguish between things and  **no implicit order**. Therefore if you would change the order of its values, the meaning would not change.

<!-- | Bad idea | Good idea |
|---|---|
| <img src="./img/01-Type-Data/01-01-Categorical%20Nominal%20pie.png" > | <img src="./img/01-Type-Data/01-03-Categorical%20nominal%20vertical%20bars.png">  |
| comments | -->

<table>
<thead>
  <tr>
    <th colspan="3"><em>Categorical data: Nominal</em></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2"><b>Bad idea</b></td>
    <td rowspan="2"><b>Good idea</b></td>
    <td rowspan="2"><b>Even better idea</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><img src="./img/01-Type-Data/01-01-Categorical%20Nominal%20pie.png"></td>
    <td><img src="./img/01-Type-Data/01-03-Categorical%20nominal%20vertical%20bars.png"></td>
    <td><img src="./img/01-Type-Data/01-02-Categorical%20nominal%20horizontal%20bars.png"></td>
  </tr>
  <tr>
    <td>When there are so many labels, the pie chart <b>does not allow to easily identify</b> which is the category with the greatest or smallest amount.</td>
    <td>A <b>bar chart</b> is a good idea to compare the amounts by categories. Notice that the <b>order of the x-axis is alphabetical</b> but changing it wouldn't change the meaning because the labels have no implicit order.</td>
    <td>For <b>long-text labels</b> is a better idea to use a <b>horizontal bar chart</b> to avoid the inclination of the words in the axis. Besides, as the alphabetical order has no meaning, it is a better idea to <b>order the bars by amount</b>.</td>
  </tr>
</tbody>
</table>

&nbsp;

  - **Ordinal**: **Labels** in which **order matters**.

<table>
<thead>
  <tr>
    <th colspan="2"><em>Categorical data: Ordinal</em></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2"><b>Bad idea</b></td>
    <td rowspan="2"><b>Good idea</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><img src="./img/01-Type-Data/01-04-Categorical%20ordinal%20pie.png"></td>
    <td><img src="./img/01-Type-Data/01-05-Categorical%20ordinal%20columns.png"></td>
  </tr>
  <tr>
    <td>As there are fewer categories, the pie may have worked. However,<b> one category gets lost</b> in the pie because <b>its value is far smaller</b> than the others.</td>
    <td>The bar chart <b>shows all the categories</b>, even the one far smaller than the others. Besides, it makes senses to <b>order the seasons as they happen</b> instead of using an alphabetical or numerical ordering.</td>
  </tr>
</tbody>
</table>

&nbsp;

  - **Hierarchical**: **Labels** in which exists a **hierarchical structure** between multiple attributes that can be aggregated up to facilitate comprehension in a visualization.

<table>
<thead>
  <tr>
    <th colspan="2"><em>Categorical data: Hierarchical</em></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2"><b>Good idea</b></td>
    <td rowspan="2"><b>Good idea</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><img src="./img/01-Type-Data/01-06-Hierarchical%20matrix.png"></td>
    <td><img src="./img/01-Type-Data/01-07%20Hierarchical%20decomposition%20tree.png"></td>
  </tr>
  <tr>
    <td>Hierarchies can be easily represented in a <b>matrix using indent and grouping</b> capabilities. It allows <b>summarizing by each level</b> of the hierarchy.</td>
    <td>Hierarchies can be shown in <b>decomposition trees</b> to highlight the expansion of a certain value or to allow the user to interact with the levels of the hierarchy.</td>
  </tr>
</tbody>
</table>

&nbsp;

## Quantitative data

Quantitative data represents a **numeric counts or measurements** that supports arithmetic comparison.

It can be classified in two categories which can be easily identified by the following question: *Can the data be divided up into smaller and smaller parts?*

- **Discrete**: If the answer is *no*, we are speaking about discrete data which values are distinct and separate. This means that data **can only take on certain values**. 

<table>
<thead>
  <tr>
    <th colspan="2"><em>Quantitative data: Discrete</em></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td colspan="2" rowspan="2"><b>Good idea</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td colspan="2"><img src="./img/01-Type-Data/01-08%20Discrete%20card.png"></td>
  </tr>
  <tr>
    <td colspan="2">When formatting a discrete number, it is a good practice to <b>remove decimals</b> as the nature of data does not allow them.</td>
  </tr>
</tbody>
</table>

&nbsp;

- **Continuous**:  If the answer is *yes*, we are speaking about continuous data which can be divided into:
  - **Interval data** which represents numeric **ordered units that have the exact same difference** between the values. *E.g. temperature scales.*
  This data **does not have a true zero** which means we can add and subtract, but we cannot multiply, divide or calculate ratios. As a consequence, a lot of descriptive and inferential statistics can not be applied.
  - **Ratio data** which are also ordered units that have the same difference but with the difference that **it has an absolute zero.**. *E.g. height, weight, length.*

<table>
<thead>
  <tr>
    <th colspan="2"><em>Quantitative data: Continuous</em></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td colspan="2" rowspan="2"><b>Good idea</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td colspan="2"><img src="./img/01-Type-Data/01-10%20Continuous%20card.png"></td>
  </tr>
  <tr>
    <td colspan="2">When formatting a continuous number, it is a good practice to <b>specify the number of decimals</b> based on the real meaning of the variable. Besides, if the meaning requires, <b>add the proper symbols</b> for the category.</td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<thead>
  <tr>
    <th colspan="2"><em>Example: Same variable, different types = TIME</em></th>
  </tr>
</thead>
<tbody>
<tr>
    <td rowspan="2" colspan="2"><b>Time as a CATEGORICAL variable</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td rowspan="2"><img src="./img/01-Type-Data/01-13%20Time%20as%20categorical.png"></td>
    <td rowspan="2"><b>Bad idea</b>
      <br>
      When using a <b>pie chart</b>, the variable is beign shown as <b>categorical</b>. Time is not a categorical variable so it is not easy for our brains to compare the different values over time.
      </td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td rowspan="2" colspan="2"><b>Time as a DISCRETE variable</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><img src="./img/01-Type-Data/01-14%20Time%20as%20discrete%20bad.png"></td>
    <td><img src="./img/01-Type-Data/01-15%20Time%20as%20discrete%20good.png"></td>
  </tr>
  <tr>
    <td><b>Bad idea</b>
      <br>
      <b>Vertical bars</b> represent the time as a <b>discrete</b> variable where the data only takes <b>certain values equally separated: months</b>. However, it makes no sense to order by descending values as done is many visualizations with bars.
      </td>
    <td><b>Good idea</b>
      <br>
      As time is an <b>ordered variable</b>, it makes more sense to order the visualization by the <b>natural order of the months</b>.
      </td>
  </tr>
  <tr>
    <td rowspan="2" colspan="2"><b>Time as a CONTINUOUS variable</b></td>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><img src="./img/01-Type-Data/01-16%20Time%20as%20continous%20bad.png"></td>
    <td><img src="./img/01-Type-Data/01-17%20Time%20as%20continous%20good.png"></td>
  </tr>
  <tr>
    <td><b>Bad idea</b>
      <br>
      A <b>line chart</b> represents the time as a <b>continuous</b> variable where the data <b>may be divided into smaller pieces with logical meaning</b>. This interpretation relates to a <b>time series and trends over time</b>. However, again, organizing by value makes no sense.
      </td>
    <td><b>Good idea</b>
      <br>
       Time remains as a variable with a <b>natural order regardless if it is treated as a discrete or as a continuous variable</b>. There, with time, it always prevails the natural order of the time unless it is a very specific business requirement.
       </td>
  </tr>
</tbody>
</table>

&nbsp;


| [Previous](./DataViz_Index.md) | [Back to Agenda](./DataViz_Index.md)  | [Next](./02-DV-Encode-Data.md) |
| :---------|:----------:|---------: |
