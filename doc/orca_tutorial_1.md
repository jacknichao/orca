
# How to use ORCA

ORCA is an experimental framework focused on productivity and experiments reproducibility for machine learning researchers. Although initially created to collect ordinal classification methods, it is also suitable for other classifiers.

First, you will need to install the framework. To do so, please visit [ORCA Quick Install Guide](orca-quick-install.md). Note that you should be able to perform the test when the framework is successfully installed.

This tutorial uses tree small datasets (`pasture`, `tae`, `toy`) contained in folder [example data](../exampledata/30-holdout). The datasets are already partitioned with a 30-holdout experimental design.

This tutorial has been tested in Octave 4.2 and 4.4, but it should work with minor changes in Matlab. 

*NOTE:*

Small datasets like the ones used in this tutorial usually produce warning messages such as:
```MATLAB
Warning: Matrix is close to singular or badly scaled. Results may be inaccurate. RCOND =
1.747151e-17.
Warning: Maximum likelihood estimation did not converge.  Iteration limit
exceeded.  You may need to merge categories to increase observed counts.

```

You can disable these messages by using the following code in Matlab:
```MATLAB
warning('off','MATLAB:nearlySingularMatrix')
warning('off','stats:mnrfit:IterOrEvalLimit')
```

In Octave, to disable `warning: matrix singular to machine precision` we need to disable all the warnings: 
```MATLAB
warning('off','all');
```

## Launch experiments through `ini` files

In this section, we run several experiments to compare the performance of three methods in a set of datasets: POM (Proportional Odds Model) [1], SVORIM (Support Vector Machines with IMplicit constrains) [2] and SVC1V1 (SVM classifier with 1-vs-1 binary decomposition) [3]. POM is a linear ordinal model, with limited performance but easy interpretation. SVORIM is an ordinal nonlinear model, with one of the most competitive performances according to several studies. SVC1V1 is the nominal counterpart of SVORIM, so that we can check the benefits of considering the order of the classes. To learn more about ordinal performance metrics see [4].

From the Octave console load packages and add orca files to path:


```octave
% Install dataframe, add src to path and disable some warnings
pkg install -forge dataframe
warning('off','all');

addpath('../src/Algorithms/')
addpath('../src/Measures/')
addpath('../src/Utils/')

```

    For information about changes from previous versions of the dataframe package, run 'news dataframe'.


The set of experiments described in INI file `tutorial/config-files/pom.ini` can be run by (the syntax of these files will be explained in the [next subsection](#Syntax-of-ini-files)):


```octave
Utilities.runExperiments('tutorial/config-files/pom.ini')
```

    Setting up experiments...
    Running experiment exp-pom-tutorial-pasture-1.ini
    Running experiment exp-pom-tutorial-pasture-10.ini
    Running experiment exp-pom-tutorial-pasture-11.ini
    Running experiment exp-pom-tutorial-pasture-12.ini
    Running experiment exp-pom-tutorial-pasture-13.ini
    Running experiment exp-pom-tutorial-pasture-14.ini
    Running experiment exp-pom-tutorial-pasture-15.ini
    Running experiment exp-pom-tutorial-pasture-16.ini
    Running experiment exp-pom-tutorial-pasture-17.ini
    Running experiment exp-pom-tutorial-pasture-18.ini
    Running experiment exp-pom-tutorial-pasture-19.ini
    Running experiment exp-pom-tutorial-pasture-2.ini
    Running experiment exp-pom-tutorial-pasture-20.ini
    Running experiment exp-pom-tutorial-pasture-21.ini
    Running experiment exp-pom-tutorial-pasture-22.ini
    Running experiment exp-pom-tutorial-pasture-23.ini
    Running experiment exp-pom-tutorial-pasture-24.ini
    Running experiment exp-pom-tutorial-pasture-25.ini
    Running experiment exp-pom-tutorial-pasture-26.ini
    Running experiment exp-pom-tutorial-pasture-27.ini
    Running experiment exp-pom-tutorial-pasture-28.ini
    Running experiment exp-pom-tutorial-pasture-29.ini
    Running experiment exp-pom-tutorial-pasture-3.ini
    Running experiment exp-pom-tutorial-pasture-30.ini
    Running experiment exp-pom-tutorial-pasture-4.ini
    Running experiment exp-pom-tutorial-pasture-5.ini
    Running experiment exp-pom-tutorial-pasture-6.ini
    Running experiment exp-pom-tutorial-pasture-7.ini
    Running experiment exp-pom-tutorial-pasture-8.ini
    Running experiment exp-pom-tutorial-pasture-9.ini
    Running experiment exp-pom-tutorial-tae-1.ini
    Running experiment exp-pom-tutorial-tae-10.ini
    Running experiment exp-pom-tutorial-tae-11.ini
    Running experiment exp-pom-tutorial-tae-12.ini
    Running experiment exp-pom-tutorial-tae-13.ini
    Running experiment exp-pom-tutorial-tae-14.ini
    Running experiment exp-pom-tutorial-tae-15.ini
    Running experiment exp-pom-tutorial-tae-16.ini
    Running experiment exp-pom-tutorial-tae-17.ini
    Running experiment exp-pom-tutorial-tae-18.ini
    Running experiment exp-pom-tutorial-tae-19.ini
    Running experiment exp-pom-tutorial-tae-2.ini
    Running experiment exp-pom-tutorial-tae-20.ini
    Running experiment exp-pom-tutorial-tae-21.ini
    Running experiment exp-pom-tutorial-tae-22.ini
    Running experiment exp-pom-tutorial-tae-23.ini
    Running experiment exp-pom-tutorial-tae-24.ini
    Running experiment exp-pom-tutorial-tae-25.ini
    Running experiment exp-pom-tutorial-tae-26.ini
    Running experiment exp-pom-tutorial-tae-27.ini
    Running experiment exp-pom-tutorial-tae-28.ini
    Running experiment exp-pom-tutorial-tae-29.ini
    Running experiment exp-pom-tutorial-tae-3.ini
    Running experiment exp-pom-tutorial-tae-30.ini
    Running experiment exp-pom-tutorial-tae-4.ini
    Running experiment exp-pom-tutorial-tae-5.ini
    Running experiment exp-pom-tutorial-tae-6.ini
    Running experiment exp-pom-tutorial-tae-7.ini
    Running experiment exp-pom-tutorial-tae-8.ini
    Running experiment exp-pom-tutorial-tae-9.ini
    Running experiment exp-pom-tutorial-toy-1.ini
    Running experiment exp-pom-tutorial-toy-10.ini
    Running experiment exp-pom-tutorial-toy-11.ini
    Running experiment exp-pom-tutorial-toy-12.ini
    Running experiment exp-pom-tutorial-toy-13.ini
    Running experiment exp-pom-tutorial-toy-14.ini
    Running experiment exp-pom-tutorial-toy-15.ini
    Running experiment exp-pom-tutorial-toy-16.ini
    Running experiment exp-pom-tutorial-toy-17.ini
    Running experiment exp-pom-tutorial-toy-18.ini
    Running experiment exp-pom-tutorial-toy-19.ini
    Running experiment exp-pom-tutorial-toy-2.ini
    Running experiment exp-pom-tutorial-toy-20.ini
    Running experiment exp-pom-tutorial-toy-21.ini
    Running experiment exp-pom-tutorial-toy-22.ini
    Running experiment exp-pom-tutorial-toy-23.ini
    Running experiment exp-pom-tutorial-toy-24.ini
    Running experiment exp-pom-tutorial-toy-25.ini
    Running experiment exp-pom-tutorial-toy-26.ini
    Running experiment exp-pom-tutorial-toy-27.ini
    Running experiment exp-pom-tutorial-toy-28.ini
    Running experiment exp-pom-tutorial-toy-29.ini
    Running experiment exp-pom-tutorial-toy-3.ini
    Running experiment exp-pom-tutorial-toy-30.ini
    Running experiment exp-pom-tutorial-toy-4.ini
    Running experiment exp-pom-tutorial-toy-5.ini
    Running experiment exp-pom-tutorial-toy-6.ini
    Running experiment exp-pom-tutorial-toy-7.ini
    Running experiment exp-pom-tutorial-toy-8.ini
    Running experiment exp-pom-tutorial-toy-9.ini
    Calculating results...
    Experiments/exp-2019-5-3-14-17-30/Results/pasture-pom-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-30/Results/tae-pom-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-30/Results/toy-pom-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-30/Results/pasture-pom-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-30/Results/tae-pom-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-30/Results/toy-pom-tutorial/dataset
    ans = Experiments/exp-2019-5-3-14-17-30


As can be observed, ORCA analyses all the files included in the folder of the dataset, where training and test partitions are included (a pair of files `train_dataset.X` and `test_dataset.X` for each dataset, where `X` is the number of partition). For each partition, a model is trained on training data and tested on test data.

After this, you can also run the experiments for SVORIM and SVC1V1:



```octave
Utilities.runExperiments('tutorial/config-files/svorim-3holdout.ini')
Utilities.runExperiments('tutorial/config-files/svc1v1-3holdout.ini')
```

    Setting up experiments...
    Running experiment exp-svorim-mae-tutorial-pasture-1.ini
    Running experiment exp-svorim-mae-tutorial-pasture-2.ini
    Running experiment exp-svorim-mae-tutorial-pasture-3.ini
    Running experiment exp-svorim-mae-tutorial-tae-1.ini
    Running experiment exp-svorim-mae-tutorial-tae-2.ini
    Running experiment exp-svorim-mae-tutorial-tae-3.ini
    Running experiment exp-svorim-mae-tutorial-toy-1.ini
    Running experiment exp-svorim-mae-tutorial-toy-2.ini
    Running experiment exp-svorim-mae-tutorial-toy-3.ini
    Calculating results...
    Experiments/exp-2019-5-3-14-17-58/Results/pasture-svorim-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-58/Results/tae-svorim-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-58/Results/toy-svorim-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-58/Results/pasture-svorim-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-58/Results/tae-svorim-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-17-58/Results/toy-svorim-mae-tutorial/dataset
    ans = Experiments/exp-2019-5-3-14-17-58
    Setting up experiments...
    Running experiment exp-svc1v1-mae-tutorial-pasture-1.ini
    Running experiment exp-svc1v1-mae-tutorial-pasture-2.ini
    Running experiment exp-svc1v1-mae-tutorial-pasture-3.ini
    Running experiment exp-svc1v1-mae-tutorial-tae-1.ini
    Running experiment exp-svc1v1-mae-tutorial-tae-2.ini
    Running experiment exp-svc1v1-mae-tutorial-tae-3.ini
    Running experiment exp-svc1v1-mae-tutorial-toy-1.ini
    Running experiment exp-svc1v1-mae-tutorial-toy-2.ini
    Running experiment exp-svc1v1-mae-tutorial-toy-3.ini
    Calculating results...
    Experiments/exp-2019-5-3-14-18-10/Results/pasture-svc1v1-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-18-10/Results/tae-svc1v1-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-18-10/Results/toy-svc1v1-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-18-10/Results/pasture-svc1v1-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-18-10/Results/tae-svc1v1-mae-tutorial/dataset
    Experiments/exp-2019-5-3-14-18-10/Results/toy-svc1v1-mae-tutorial/dataset
    ans = Experiments/exp-2019-5-3-14-18-10


Once the experiments are finished, the corresponding results can be found in the `Experiments` subfolder, as described in the [corresponding section](#Experimental-results-and-reports) of this tutorial.

Each experiment has a different folder, and each folder should include two CSV files with results similar to the following (some columns are omitted):

POM results ([download CSV](tutorial/reference-results/pom-mean-results_test.csv)):

| Dataset-Experiment | MeanMAE | StdMAE | MeanAMAE | StdAMAE | MeanTrainTime | StdTrainTime |
| --- | --- | --- | --- | --- | --- | --- |
| pasture-pom-tutorial | 0.6 | 0.230866 | 0.6 | 0.230866 | 0.070958 | 0.004822 |
| tae-pom-tutorial | 0.615789 | 0.100766 | 0.616952 | 0.101876 | 0.324884 | 0.087447 |
| toy-pom-tutorial | 0.980889 | 0.038941 | 1.213242 | 0.059357 | 0.038949 | 0.002738 |

SVORIM results ([download CSV](tutorial/reference-results/svorim-mean-results_test.csv)):

| Dataset-Experiment | MeanMAE | StdMAE | MeanAMAE | StdAMAE | MeanTrainTime | StdTrainTime |
| --- | --- | --- | --- | --- | --- | --- |
| pasture-svorim-mae-real | 0.322222 | 0.106614 | 0.322222 | 0.106614 | 0.013843 | 0.002601 |
| tae-svorim-mae-real | 0.475439 | 0.069086 | 0.473291 | 0.068956 | 0.042999 | 0.023227 |
| toy-svorim-mae-real | 0.017778 | 0.012786 | 0.019631 | 0.015726 | 0.071385 | 0.025767 |

SVC1V1 results ([download CSV](tutorial/reference-results/svc1v1-mean-results_test.csv)):

| Dataset-Experiment | MeanMAE | StdMAE | MeanAMAE | StdAMAE | MeanTrainTime | StdTrainTime |
| --- | --- | --- | --- | --- | --- | --- |
| pasture-svc1v1-mae-tutorial | 0.314815 | 0.127468 | 0.314815 | 0.127468 | 0.014363 | 0.003297 |
| tae-svc1v1-mae-tutorial | 0.534211 | 0.108865 | 0.533832 | 0.110083 | 0.017699 | 0.004122 |
| toy-svc1v1-mae-tutorial | 0.051556 | 0.023419 | 0.044367 | 0.022971 | 0.015869 | 0.003786 |

---

---

***Exercise 1***: apparently, POM is the slowest method, but here we are not considering the crossvalidation time. Check the detailed CSV results to conclude which is the method with the lowest computational cost (taking crossvalidation, training and test phases into account).

---

Finally, you can plot a bar plot to graphically compare the performance of the methods. Let's analyse for that the `toy` dataset. This is a synthetic dataset proposed by Herbrich et al. in their paper "Support vector learning for ordinal regression" (1997):

![Synthetic toy dataset](tutorial/images/toy.png)

The following code plots the figure below:


```octave
pkg load dataframe
pomT = dataframe('tutorial/reference-results/pom-mean-results_test.csv');
svorimT = dataframe('tutorial/reference-results/svorim-mean-results_test.csv');
svc1v1T = dataframe('tutorial/reference-results/svc1v1-mean-results_test.csv');
datasets = {'pasture','tae','toy'};

bar([pomT.MeanAMAE svorimT.MeanAMAE svc1v1T.MeanAMAE])
set (gca, 'xticklabel',datasets)
legend('POM  ', 'SVORIM', 'SVC1V1')
title('AMAE performance (smaller is better)')
```


![png](orca_tutorial_1_files/orca_tutorial_1_10_0.png)



---

***Exercise 2***: you can repeat this barplot but now considering:
- A `global` (i.e. a metric where the class a priori probability is not considered) **nominal** metric.
- A `global` **ordinal** metric.
- A **nominal** metric specifically designed for imbalanced datasets.
- An **ordinal** metric specifically designed for imbalanced datasets.

---

### Syntax of `ini` files

ORCA experiments are specified in configuration `ini` files, which execute an algorithm for a collection of datasets (each dataset with a given number of partitions). The folder [src/config-files](../src/config-files) contains example configuration files for running all the algorithms included in ORCA for all the algorithms and datasets of the [review paper](http://www.uco.es/grupos/ayrna/orreview). The following code is an example for running the Proportion Odds Model (POM), a.k.a. Ordinal Logistic Regression. Note that the execution of this `ini` file can take several hours:
```INI
; Experiment ID
[pom-real
{general-conf}
seed = 1
; Datasets path
basedir = ../../../datasets/ordinal/real/30-holdout
; Datasets to process (comma separated list or 'all' to process all)
datasets = automobile,balance-scale,bondrate,car,contact-lenses,ERA,ESL,eucalyptus,LEV,marketing,newthyroid,pasture,squash-stored,squash-unstored,SWD,tae,thyroid,toy,winequality-red,winequality-white
; Activate data standardization
standarize = true

; Method: algorithm and parameter
{algorithm-parameters}
algorithm = POM
```

`ini` files include **Subsections** to help organize the configuration. These sections are mandatory:
 - `{general-conf}`: generic parameters of the experiment, including the seed considered for random number generation, the directory containing the datasets, the datasets to be processed... All the parameters included here are the same for all the algorithms.
 - `{algorithm-parameters}`: here you can specify the algorithm to run and the parameters which are going to be fixed (not optimized through cross validation).
 - `{algorithm-hyper-parameters-to-cv}`: algorithms' hyper-parameters to optimise. For more details, see [Hyper-parameter optimization](#Hyper-parameter-optimization).

The above file tells ORCA to run the algorithm `POM` for all the datasets specified in the list `datasets`. You can also use `datasets = all` to process all the datasets in `basedir`). Each of these datasets should be found at folder `basedir`, in such a way that ORCA expects one subfolder for each dataset, where the name of the subfolder must match the name of the dataset. Other directives are:
 - INI section `[pom-real]` sets the experiment identifier.
 - The `standarize` flag activates the standardization of the data (by using the mean and standard deviation of the train set).
 - The rest of the parameters of the model depend on the specific algorithm (and they should be checked in the documentation of the algorithm). For instance, the kernel type is set up with `kernel` parameter.


### Hyper-parameter optimization

Many machine learning methods are very sensitive to the value considered for the hyper-parameters (consider, for example, support vector machines and the two associated parameters, cost and kernel width). ORCA automates hyper-parameter optimization by using a grid search with an internal nested *k*-fold cross-validation considering only the training partition. Let see an example for the optimisation of the two hyper-parameters of SVORIM: cost (`C`) and kernel width parameter (`k`, a.k.a. *gamma*):
```ini
; Experiment ID
[svorim-mae-real]
{general-conf}
seed = 1
; Datasets path
basedir = datasets/ordinal/real/30-holdout
; Datasets to process (comma separated list)
datasets = all
; Activate data standardization
standarize = true
; Number of folds for the parameters optimization
num_folds = 5
; Crossvalidation metric
cvmetric = mae

; Method: algorithm and parameter
{algorithm-parameters}
algorithm = SVORIM
kernel = rbf

; Method's hyper-parameter values to optimize
{algorithm-hyper-parameters-to-cv}
C = 10.^(-3:1:3)
k = 10.^(-3:1:3)
```

The directive for configuring the search process is included in the general section. The directives associated to hyper-parameter optimisation are:
- `seed`: is the value to initialize MATLAB random number generator. This can be helpful to debug algorithms.
- `num_folds`: *k* value for the nested *k*-fold cross validation over the training data.
- `cvmetric`: metric used to select the best hyper-parameters in the grid search. The metrics available are: `AMAE`,`CCR`,`GM`,`MAE`,`MMAE`,`MS`,`MZE`,`Spearman`,`Tkendall` and `Wkappa`.
- The list of hyper-parameters to be optimised and values considered for each parameter during the grid search are specified in subsection `{algorithm-hyper-parameters-to-cv}`;
    - `C`: add a new parameter with name `C` and a set of values of `10.^(-3:1:3)` (10<sup>-3</sup>,10<sup>-2</sup>,...,10<sup>3</sup>). The same apples for `k`.

The parameter optimization can also be done by using the API (full example is in [exampleParamOptimization.m](../src/code-examples/exampleParamOptimization.m) script):


```octave
% Load the different partitions of the dataset
load ../exampledata/1-holdout/toy/matlab/train_toy.0
load ../exampledata/1-holdout/toy/matlab/test_toy.0

% "patterns" refers to the input variables and targets to the output one
train.patterns = train_toy(:,1:end-1);
train.targets = train_toy(:,end);
test.patterns = test_toy(:,1:end-1);
test.targets = test_toy(:,end);

% Assumes training set in structure 'train'
% Create the algorithm object
algorithmObj = KDLOR();
% Create vectors of values to test
param.C = 10.^(-3:1:3);
param.k = 10.^(-3:1:3);
param.u = [0.01,0.001,0.0001,0.00001];

% Optimizing parameters for KDLOR with metric MAE (default metric)
optimalp = paramopt(algorithmObj,param,train)

% Optimizing parameters for KDLOR with metric GM
optimalp = paramopt(algorithmObj,param,train, 'metric', GM)
```

    optimalp =
    
      scalar structure containing the fields:
    
        C =  0.0010000
        k =  10
        u =  0.00010000
    
    optimalp =
    
      scalar structure containing the fields:
    
        C =  0.0010000
        k =  10
        u =  0.010000
    


### Experimental results and reports

ORCA uses the `Experiments` folder to store all the results of the different experiments. Each report is placed in a subfolder of `Experiments` named with the current date, time and the name of the configuration file (for example 'exp-2015-7-14-10-5-57-pom'). After a successful experiment, this folder should contain the following information:
 - Individual experiment configuration files for each dataset and partition.
 - A `Results` folder with the following information:
    - `mean-results_train.csv` and `mean-results_test.csv` which are the reports in CSV format (easily read by Excel or LibreOffice Calc). They contain the mean and standard deviation for each performance measure (`AMAE`,`CCR`,`GM`,`MAE`,`MMAE`,`MS`,`MZE`,`Spearman`,`Tkendall` and `Wkappa`) and the computational time. These averages and standard deviations are obtained for all the partitions of each algorithm and dataset.
    - The `Results` folder contains one subfolder for each dataset with the following data:
        - Train and test confusion matrices (`matrices.txt`).
        - Name of the folder used for the experiments (`dataset`).
        - Individual results for each partition in CSV format (`results.csv`).
        - Models of each partition in `.mat` format (`Models` folder). These models are structures and their fields depend on the specific algorithm.
        - Decision values used to obtain the predicted labels for training and test partitions ('Guess' folder). For threshold models, this is the one dimensional mapping before applying the discretisation based on the thresholds. The rest of models may have multidimensional mappings.
        - Labels predicted by the models for each partition ('Predictions' folder).
        - Optimal hyper-parameters values obtained after nested cross-validation ('OptHyperparams').
        - Computational time results ('Times').

If you provide the option `report_sum = true` in `{general-conf}`, additionally the same metrics will be calculated with a matrix that is the sum of the generalization matrices (as Weka does). **Note that this only makes sense in the case of a k-fold experimental design**. With this option active, two additional reports will be generated (`mean-results_matrices_sum_train.csv` and `mean-results_matrices_sum_test.csv`)

## Running algorithms with ORCA API

### Run a pair of train-test files with fitpredict

ORCA algorithms can be used from your own Matlab code. All algorithms included in the [Algorithms](../src/Algorithms) have a `fitpredict` method, which can be used for running the algorithms with your data. The method receives a structure with the matrix of training data and labels, the equivalent for test data and a structure with the values of the parameters associated to the method. With respect to other tools, parameters are a mandatory argument for the method to avoid the use of default values.

For example, the [KDLOR (Kernel Discriminant Learning for Ordinal Regression)](../src/Algorithms/KDLOR.m) [5]  method has a total of five parameters. Two of them (the type of kernel, `kernelType`, and the optimisation routine considered, `optimizationMethod`) are received in the constructor of the corresponding class, and the other three parameters (cost, `C`, kernel parameter, `k`, and value to avoid singularities, `u`) are supposed to have to be fine-tuned for each dataset and partition, so they are received in a structure passed to the `fitpredict` method.

This an example of execution of KDLOR from the Matlab console:


```octave
addpath('../src/Algorithms/')
kdlorAlgorithm = KDLOR('kernelType','rbf','optimizationMethod','quadprog');
kdlorAlgorithm
```

    kdlorAlgorithm =
    
    <object KDLOR>
    


Load train and test data:


```octave
load ../exampledata/1-holdout/toy/matlab/train_toy.0
load ../exampledata/1-holdout/toy/matlab/test_toy.0
train.patterns = train_toy(:,1:(size(train_toy,2)-1));
train.targets = train_toy(:,size(train_toy,2));
test.patterns = test_toy(:,1:(size(test_toy,2)-1));
test.targets = test_toy(:,size(test_toy,2));
param.C = 10;
param.k = 0.1;
param.u = 0.001;
param
```

    param =
    
      scalar structure containing the fields:
    
        C =  10
        k =  0.10000
        u =  0.0010000
    


Fit the model and test prediction with generalization data:


```octave
info = kdlorAlgorithm.fitpredict(train,test,param);
fieldnames(info)
```

    ans =
    {
      [1,1] = projectedTrain
      [2,1] = predictedTrain
      [3,1] = trainTime
      [4,1] = projectedTest
      [5,1] = predictedTest
      [6,1] = testTime
      [7,1] = model
    }
    


Calculate accuracy:


```octave
fprintf('Accuracy Train %f, Accuracy Test %f\n',
    sum(train.targets==info.predictedTrain)/size(train.targets,1),
    sum(test.targets==info.predictedTest)/size(test.targets,1));
```

    Accuracy Train 0.871111, Accuracy Test 0.853333


As we can see, the methods return a structure with the main information about the execution of the algorithm. The fields of this structure are:
- `projectedTrain`: decision values for the training set.
- `predictedTrain`: labels predicted for the training set.
- `trainTime`: time in seconds needed for training the model.
- `projectedTest`: decision values for the test set.
- `predictedTest`: labels predicted for the test set.
- `testTime`: time in seconds needed for the test phase.
- `model`: structure containing the model (its coefficients, parameters, etc.). Note that, although most of the fields of this structure depend on the specific algorithm considered, we will always find the `algorithm` and `parameters` fields. These are the fields for KDLOR:


```octave
fieldnames(info.model)
```

    ans =
    {
      [1,1] = projection
      [2,1] = thresholds
      [3,1] = parameters
      [4,1] = kernelType
      [5,1] = train
      [6,1] = algorithm
    }
    


i.e., the algorithm used for training (`algorithm`), the weight given to each pattern in the kernel model (`projection`), the set of threshold values (`thresholds`), the parameters used for training (`parameters`), the type of kernel considered (`kernelType`) and the training data (`train`). As can be checked, at least, this structure should contain the information for performing the test phase. In this way, for KDLOR, the prediction phase needs to apply the kernel to each training point and the test point being evaluated (using `kernelType`, `train` and `parameters.K`) and perform the weighted sum of these values (using `projection`). After that, the thresholds are used to obtain the labels.

The corresponding script ([exampleKDLOR.m](../src/code-examples/exampleKDLOR.m)) can be found and run in the [code example](../src/code-examples) folder.


```octave
rmpath('../src/Measures')
rmpath('../src/Algorithms')
rmpath('../src/Utils/')
```
