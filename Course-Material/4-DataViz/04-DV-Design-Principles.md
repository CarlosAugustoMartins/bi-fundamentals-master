| [Previous](./03-DV-Use-Color.md) | [Back to Agenda](./DataViz_Index.md)  | [Next](./05-DV-Types-Charts.md) |
| :---------|:----------:|---------: |

# Data Visualization Fundamentals | (4) Design principles

In this chapter, we will review:
- Gestalt Principles of Visual Perception
- Application of principles in data visualization

> The German term "gestalt" means pattern, shape, form.

`Aoccdrnig to rseearch at Cmabrigde Uinervtisy, it deosn’t mttaer in waht oredr the ltteers in a wrod are, the olny iprmoatnt tihng is taht the frist and lsat ltteer be at the rghit pclae. The rset can be a toatl mses and you can sitll raed it wouthit porbelm. Tihs is bcuseae the huamn mnid deos not raed ervey lteter by istlef, but the wrod as a wlohe.` <sub> - Abeer Hasanin 2015–2016</sub>

**The picture you see is different than the image perceived by your mind.** Gestalt principles apply to visual perception, and they detail how the brain creates structure by default. This is the reason you can read those structurally-misplaced letters at the beginning of this article as your brain is already familiar with the structure of every word used in that sentence

In 1912, the **Gestalt School of Psychology** found that **we organize what we see in particular ways in an effort to make sense of it**. The result of this study is the collection of Gestalt principles of visual perception. 

These principles offer **useful insights to apply in dashboard designs** to group data, separate it or make some information to stand out. 

## Gestalt Principles of Visual Perception

<table>
<tbody>
  <tr>
    <td><b>1. Principle of Proximity</b></td>
  </tr>
  <tr>
    <td>We perceive objects that are <b>located near one another as belonging to the same group</b>.</td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Proximity%20example.png">
    <p align="right">
      <sub>Image by Wolters J. from presentation "(Web)Design for Conversion". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/04-01-Proximity.png"></td>
  </tr>
  <tr>
    <td>This is the <b>simplest way to group data</b> that should be analyzed together such as the <b>quarters</b> that when located closer are easily identified <b>as part of the same year</b>. A bigger white space between the years than the quarters facilitates the distinction of the time frames.</td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<tbody>
  <tr>
    <td><b>2. Principle of Similarity</b></td>
  </tr>
  <tr>
    <td>We tend to <b>group together objects that are similar in color, size, chape and orientation</b>. This principle reinforces the concept of encoding data in physical attributes.
    </td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Similarity%20example.png">
    <p align="right">
      <sub>Image by Wolters J. from presentation "(Web)Design for Conversion". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/04-02-Similarity%2001.png"></td>
  </tr>
  <tr>
    <td>The <b>similarity of color</b> is a cue for our eyes to <b>read across the rows</b>, rather than down the columns. This <b>eliminates the need for additional elements</b> to separate the rows making the table look simple and clean while helps our brain to read it. The lines for the header and footer respond to another principle called "enclosure" by giving a physical delimiter that separates the sections. (This principle is explained below).</td>
  </tr>
    <tr>
    <td><img src="./img/04-Design%20principles/04-03%20Similarity%2002.png"></td>
  </tr>
  <tr>
    <td>Using the <b>color as an arbitrary decorator creates an additional cognitive load</b> to the brain trying to make sense of it. Meanwhile, <b>encoding the "Category" variable into the color attribute</b>, allow us to use the similarity principle to easily identify the points in the chart that belong to the same film category.</td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<tbody>
  <tr>
    <td><b>3. Principle of Enclosure</b></td>
  </tr>
  <tr>
    <td>We perceive objects as <b>belonging together when they are enclosed by a visual border</b> around them such as a <b>line or a field of color</b>. This enclosure sets that region apart from the rest.</td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Enclosure%20example.jpg">
    <p align="right">
      <sub>Image by Few S. from book "Information Dashboard Design: The Effective Visual Communication of Data". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/04-04-Enclosure.png"></td>
  </tr>
  <tr>
    <td>When adding a forecast to a line chart, it is important to identify clearly and easily <b>which part is based on the data and which part is predicted</b>. Only changing the type of line, is not enough to create a clear identification. When using a <b>field of color in the forecasted</b> section, it <b>creates a distinction</b> of this area and at the same time, it is <b>encoding the confidence interval</b> for the forecast. </td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<tbody>
  <tr>
    <td><b>4. Principle of Closure</b></td>
  </tr>
  <tr>
    <td>Humans have a dislike for loose ends. We like things to be simple and to fit in the constructs on our heads. So when we face shapes that are incomplete or open, <b>we tend to close them to make them look like regular known shapes</b>. This means that we tend to <b>perceive a set of individual elements as a single organized shape</b>.</td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Closure%20example.jpg">
    <p align="right">
      <sub>Image by Wolters J. from presentation "(Web)Design for Conversion". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/04-06-Closure%20Part%201.png">
    <img src="./img/04-Design%20principles/04-06-%20Closure%20Part%202.png"></td>
  </tr>
  <tr>
    <td>When <b>dividing a dashboard into different sections</b> is possible to take advantage of our ability to close open shapes. In this way, we can use <b>only the superior line of every section</b> to give the brain a cue that all those elements belong to the same section. This <b>eliminates the need to use borders</b> to close every section and allows for a simpler and lighter design. </td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<tbody>
  <tr>
    <td><b>5. Principle of Continuity</b></td>
  </tr>
  <tr>
    <td>We perceive <b>objects as belonging together</b>, as part of a single whole, if they are <b>aligned with one another</b> or <b>appear to form a continuation</b> of one another.</td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Continuity%20example.jpg">
    <p align="right">
      <sub>Image by Few S. from book "Information Dashboard Design: The Effective Visual Communication of Data". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/04-05%20Continuity.png"></td>
  </tr>
  <tr>
    <td>This table contains <b>hierarchical data</b> so it is important to be able to represent the different levels of the hierarchy. Using the principle of continuity, <b>we can align with different levels of indentation, the distinct levels of the geographical hierarchy</b>. The brain recognizes as part of one group all the elements aligned with one another.</td>
  </tr>
</tbody>
</table>

&nbsp;

<table>
<tbody>
  <tr>
    <td><b>6. Principle of Connection</b></td>
  </tr>
  <tr>
    <td>We perceive <b>objects connected in some way, such as by a line, as part of the same group</b>. This connection <b>groups tha data in a more powerful way than any other visual means</b> such as position, size or shape. It is <b>weaker only than</b> the grouping produced by the <b>enclosure</b>.</td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Connection%20example.jpg">
    <p align="right">
      <sub>Image by Few S. from book "Information Dashboard Design: The Effective Visual Communication of Data". <i>See References for more details</i>.</sub>
    </p>
    <img src="./img/04-Design%20principles/Connection%20example%202.png">
    </td>
  </tr>
  <tr>
    <td>
    In this network visualization, there are different colors for the data points which informs us about different categories. However, <b>the relation created for the lines connecting nodes is much more powerful</b>.
    </td>
  </tr>
  <tr>
    <td>
    <img src="./img/04-Design%20principles/Connection%20line.png">
    </td>
  </tr>
    <tr>
    <td>
    When the <b>line becomes thicker</b>, that relationship is <b>emphasized over the others</b> and creates a <b>meaning of importance or superiority</b>, such as the main group or the central nodes of a network e.g. the heads of certain departments in a company.
    </td>
  </tr>
   <tr>
    <td>
    <img src="./img/04-Design%20principles/Connection%20example%20focus.png">
    </td>
  </tr>
    <tr>
    <td>
     Another option to focus the attention of the audience in a specific section is to <b>use the attribute color to take advantage of the principle of similarity</b>. By setting many nodes and lines to gray and respecting the colors only for certain nodes and lines, it informs the brain that <b>all the gray points belong to the same group (context)</b>. Meanwhile, the colored ones highlight in contrast to gray, <b>focusing our attention on that piece of the network</b>.
    </td>
  </tr>
</tbody>
</table>

&nbsp;

| [Previous](./03-DV-Use-Color.md) | [Back to Agenda](./DataViz_Index.md)  | [Next](./05-DV-Types-Charts.md) |
| :---------|:----------:|---------: |



