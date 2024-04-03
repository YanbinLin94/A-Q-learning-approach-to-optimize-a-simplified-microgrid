# A Q learning approach to optimize a simplified microgrid (energy arbitrage) setup
This code provides a Q learning approach to optimize a simplified microgrid (energy arbitrage) setup. This code contributes to the reference paper below, which describes a more complex setup of aggregating multiple learning agents for microgrid energy optimization during extreme weather events. 

You can read the paper at this link: [Aggregating_Learning_Agents_for_Microgrid_Energy_Scheduling_During_Extreme_Weather_Events.pdf](https://github.com/YanbinLin94/A-single-Q-learning-agent-to-optimize-a-simplified-microgrid/files/14817710/Aggregating_Learning_Agents_for_Microgrid_Energy_Scheduling_During_Extreme_Weather_Events.pdf)


## **Citation**
This code is provided for academic training, supported by the NSF CyberTraining project.
If this code is used for any research purpose, please cite our PESGM’21 paper below.
```
@INPROCEEDINGS{9637949,
  author={Das, Avijit and Ni, Zhen and Zhong, Xiangnan},
  booktitle={2021 IEEE Power & Energy Society General Meeting (PESGM)}, 
  title={Aggregating Learning Agents for Microgrid Energy Scheduling During Extreme Weather Events}, 
  year={2021},
  volume={},
  number={},
  pages={01-05},
  keywords={Schedules;Q-learning;Uncertainty;Processor scheduling;Decision making;Microgrids;Probabilistic logic;Microgrid energy scheduling;extreme weather events;energy optimization;reinforcement learning;aggregating knowledge},
  doi={10.1109/PESGM46819.2021.9637949}}
```

## **How to run**
**This code requires:**

•	MATLAB

Clone the repository and run the code
```
# clone project
git clone https://github.com/YanbinLin94/A-single-Q-learning-agent-to-optimize-a-simplified-microgrid.git
# run the code
run mainRL_v0_QTable.m
```

## **Results**
![fig1](https://github.com/YanbinLin94/A-single-Q-learning-agent-to-optimize-a-simplified-microgrid/assets/97860537/db9ea7a0-c32c-47a2-b416-2c4f99d60abb)

![fig2](https://github.com/YanbinLin94/A-Q-learning-approach-to-optimize-a-simplified-microgrid/assets/97860537/83f9f675-d448-48c4-9598-ea257a1afc94)

![fig3](https://github.com/YanbinLin94/A-single-Q-learning-agent-to-optimize-a-simplified-microgrid/assets/97860537/bfe88fd6-d4a2-42d8-9b10-aece4960453b)


## Case Studies
### Case 1: Change battery SOC discretization size and check how it affects the system 
1. Try with N = 10, 100, and 1000
2. Report results in figures (both cost curve and battery policy)
   All cost curves should be in the same figure
3. Investigate why it differs and try to find a conclusion 

### Case 2: Change the battery capacity and efficiency, and check how it affects the system 
1. For capacity, try 6 MWh with 1 MW maximum and 8 MWh with 2 MW maximum
2. For efficiency, try 80% and 95%
3. Report results in figures (both cost curve and battery policy)
   All cost curves should be in the same figure
4. Investigate why it differs and try to find a conclusion 

### Case 3: How to use a trained Q-table for making decisions?
For example, if you are at time 6, you know your current battery SOC as 0.9, how to use the trained Q-table to take the battery charging/discharging decision and calculate the corresponding cost.

