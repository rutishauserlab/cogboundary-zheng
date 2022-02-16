# Cognitive boundaries dataset example code
This repository contains example code to illustrate how to utilize the Neural Data Without Borders (NWB) formatted dataset on investigating the role of cognitive boundaries in episodic memory. The data is stored in the DANDI archive and is described in the paper below. 

## Paper
This data was used to perform the analysis reported in this paper: **Neurons detect cognitive boundaries to structure episodic memories in humans**. While experience is continuous, memories are organized as discrete events. Cognitive boundaries are thought to segment experience and structure memory, but how this process is implemented remains unclear. We recorded the activity of single neurons in the human medial temporal lobe during the formation and retrieval of memories with complex narratives. Neurons responded to abstract cognitive boundaries between different episodes. Boundary-induced neural state changes during encoding predicted subsequent recognition accuracy but impaired event order memory, mirroring a fundamental behavioral tradeoff between content and time memory. Furthermore, the neural state following boundaries was reinstated during both successful retrieval and false memories. These findings reveal a neuronal substrate for detecting cognitive boundaries that transform experience into mnemonic episodes and structure mental time travel during retrieval.

*Jie Zheng, Andrea Gómez Palacio Schjetnan, Mar Yebra, Clayton Mosher, Suneil Kalia, Taufik A. Valiante, Adam N. Mamelak, Gabriel Kreiman, Ueli Rutishauser. Nat Neurosci, 2022 (in press).*

## Links
Github: https://github.com/rutishauserlab/cogboundary-zheng
Data: https://gui.dandiarchive.org/#/dandiset/000207

## Downloading the data

After installing the DANDI CLI client, use the following commands to download the dataset
```
dandi download DANDI:000207
```

Alternatively, download individual nwb files in the web interface of DANDI. You can also use the built in CellExplorer GUI in DANDI to explore the content of the file graphically.

## Code - analysis
All analysis is implemented in Matlab and requires the [matnwb 2.4.0 API](https://github.com/NeurodataWithoutBorders/matnwb/releases/tag/v2.4.0.0) to be installed (or higher, but we only tested with 2.4.0). 

First, checkout this repository:
```
svn checkout https://github.com/rutishauserlab/cogboundary-zheng.git
```

The main function is CB_analysis_Dandi_main.m . To get started adjust the following variables accordingly:
```
basepathData = 'C:\projects\DandiDownload\000207';   % Path to Downloaded files
basePathNWBCode = 'C:\svnwork\matnwb-2.4.0.0'; % path to matnwb API. We tested with 2.4.0 release, downloaded from https://github.com/NeurodataWithoutBorders/matnwb/releases/tag/v2.4.0.0
basePathCode = 'C:\svnwork\cogboundary-zheng.git\trunk\'; % this code, downloaded from github
```

Then, set which session and type of response you would like to plot further down in the file:
```
CBID_toPlot = 4;   % Which Subject to plot (CBID, see Table in paper)
plotMode = 1;      % What to plot. 1=encoding, boundary aligned, 2=encoding, stim onset aligned. 3=recognition test, stim onset aligned. 4=time order test, stim onset aligned.
```

Now, run the file and one figure per cell will be plotted.
