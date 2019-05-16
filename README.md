# Multi-Normal Estimation via Pair Consistency Voting
ie~Zhang, Junjie Cao (co-first authors), Xiuping Liu*, He Chen, Bo Li, Ligang Liu. 
TVCG 2019
![Teaser Image](http://jjcao.github.io/images/MultiNormal.png)
The normals of feature points, the intersection points of multiple smooth surfaces, are ambiguous and undefined. <br />

### Introduction
<br>
This paper presents a unified definition for point cloud normal of feature and non-feature points, which allows
feature points to possess multiple normals.
This definition facilitates several succeeding operations, such as feature points extraction and point cloud filtering.
We also develop a feature preserving normal estimation method which outputs multiple normals per feature point.
<br />
<br />
The core of the method is a pair consistency voting scheme. All neighbor point pairs vote for the local tangent 
plane. Each vote takes the fitting residuals of the pair of points and their preliminary normal consistency into 
consideration. Thus the pairs from the same subspace and relatively far off features dominate the voting. An adaptive 
strategy is designed to overcome sampling anisotropy.
<br />
<br />
In addition, we introduce an error measure compatible with traditional normal estimators, and present the 
first benchmark for normal estimation, composed of 152 synthesized data with various features and sampling 
densities, and 288 real scans with different noise levels. Comprehensive and quantitative experiments show 
that our method generates faithful feature preserving normals and outperforms previous cutting edge normal 
estimation methods, including the latest deep learning based method.

### Normal Estimation Benchmark
#### Ground truth dataset
https://pan.baidu.com/s/1VZVWcjSr6TxqfQtfJfhk1A

<img src = "http://jjcao.github.io/images/ModelsSynthesis.png" height="300px"></img> Synthesized Data Set<br />
<img src = "http://jjcao.github.io/images/ModelsRealscan.jpg" height="480px"></img>Scanned Data Set<br />

#### Comparisons
...

### Previous work
- Jie~Zhang, Junjie Cao (co-first authors), Xiuping Liu*, He Chen, Bo Li, Ligang Liu. [Multi-Normal Estimation via Pair Consistency Voting](Multi-Normal_2019.pdf). IEEE Transactions on Visualization and Computer Graphics, 25(4), 2019, 1693-1706. 
- Junjie Cao, He Chen, Jie Zhang*, Yujiao Li, Xiuping Liu, Changqing Zou. Normal Estimation via Shifted Neighborhood for point cloud. Journal of Computational and Applied Mathematics, 2018, 329, 57-67.
- Xiuping Liu, Jie Zhang, Junjie Cao*, Bo Li, Ligang Liu. "Quality Point Cloud Normal Estimation by Guided Least Squares Representation", Computers & Graphics (Special Issue of SMI 2014), 2015, 46, 106-116.
- Jian Liu, Junjie Cao*, Xiuping Liu, Jun Wang, XiaoChao Wang, Xiquan Shi. [Mendable consistent orientation of point clouds](https://github.com/jjcao/jjcao-orientation), Computer-Aided Design, 2014, 55: 26-36.
- Jie Zhang, Junjie Cao*, Xiuping Liu, Jun Wang, Jian Liu, Xiquan Shi. [Point cloud normal estimation via low-rank subspace clustering](https://github.com/jjcao/sf-pcd2013), Computer & Graphics (Special issue of SMI), 2013, 37(6): 697-706.
- Junjie Cao*, Ying He, Zhiyang Li, Xiuping Liu, Zhixun Su. [Orienting Raw Point Sets by Global Contraction and Visibility Voting](https://github.com/jjcao/orientation1), Computer & Graphics (Special Issue of SMI 2011), 2011.
