# cogboundary-zheng
This repository contains example code to show how to utilize the Neural Data Without Borders (NWB) formatted dataset on investigating the role of cognitive boundaries in episodic memory. The data is stored in the DANDI archive and is described in the paper below. 

## Paper
**Neurons detect cognitive boundaries to structure episodic memories in humans**. While experience is continuous, memories are organized as discrete events. Cognitive boundaries are thought to segment experience and structure memory, but how this process is implemented remains unclear. We recorded the activity of single neurons in the human medial temporal lobe during the formation and retrieval of memories with complex narratives. Neurons responded to abstract cognitive boundaries between different episodes. Boundary-induced neural state changes during encoding predicted subsequent recognition accuracy but impaired event order memory, mirroring a fundamental behavioral tradeoff between content and time memory. Furthermore, the neural state following boundaries was reinstated during both successful retrieval and false memories. These findings reveal a neuronal substrate for detecting cognitive boundaries that transform experience into mnemonic episodes and structure mental time travel during retrieval.

*Jie Zheng, Andrea Gómez Palacio Schjetnan, Mar Yebra, Clayton Mosher, Suneil Kalia, Taufik A. Valiante, Adam N. Mamelak, Gabriel Kreiman, Ueli Rutishauser. bioRxiv 2021.01.16.426538*

## Downloading the data
Data: https://gui.dandiarchive.org/#/dandiset/000207

After installing the DANDI CLI client, use the following commands to download the dataset
```
dandi download DANDI:000207
```

Alternatively, download individual nwb files in the web interface of DANDI.

## Code - analysis
All analysis is implemented in Matlab and requires the [matnwb 2.4.0 API](https://github.com/NeurodataWithoutBorders/matnwb/releases/tag/v2.4.0.0) to be installed (or higher, but we only tested with 2.4.0). 

The main function is CB_analysis_main.m . Adjust the variables at the beginning to set the proper paths. Then, specify which subject to analyze (CBID) by setting XXX [todo].
