  Real Time Visualization for the DAQ IR Gait System - BSP Lab Summer 2015
  Author - Shadman Zaman Samin
  The visualizer is compatible to MCC DAQ with a legacy based system. The
  function prompts the user to select a sampling rate. The GUI is then
  generated, where the user is asked to start the collection using the START
  button. The CLEAR button closes the figure and prompts the user to save
  the file in a designated location. 
  --------------------- Hardware Set up ---------------------------------
  Below, is the detail layout of the hardware connections with the IR GAIT
  system 
  Analog Pin Connections ------------------------------------------------
  Pin 1 ----> MUX 1
  Pin 2 ----> MUX 2
  Pin 3 ----> Counter Bit 0 [LSB]
  Pin 4 ----> Counter Bit 1 
  Pin 5 ----> Counter Bit 2
  Pin 6 ----> Counter Bit 3 [MSB]
 
 
 
  ----------------------- GUI Layout -----------------------------------
  The GUI has few different components. The GUI has a sliding windows of 3
  seconds. The toolbar allows the user to make changes in the plot in real
  time. The buttons on the user interface is as follows. 
  PLAY button starts the collection. 
  CLEAR button ends collection and prompts the users to save the data. 
  MUX 1 button clear/plots the signals from MUX 1
  MUX 2 button clear/plots the signal from MUX 2
  LSB button clears/plots the signal from LSB Counter Bit