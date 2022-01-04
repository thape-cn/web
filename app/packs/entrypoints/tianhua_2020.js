global.Rails = require("@rails/ujs");
global.Rails.start();
import { submitFormButton, showOrSkipNextSceneGlobal, 
  showOrSkipPreviousSceneGlobal, setElementGlobal,
  gotoFlagBoardGlobal, pauseOrPlayMusicGlobal } from "bill/tianhua2020";
global.submitFormButton = submitFormButton
global.showOrSkipNextSceneGlobal = showOrSkipNextSceneGlobal
global.showOrSkipPreviousSceneGlobal = showOrSkipPreviousSceneGlobal
global.setElementGlobal = setElementGlobal
global.gotoFlagBoardGlobal = gotoFlagBoardGlobal
global.pauseOrPlayMusicGlobal = pauseOrPlayMusicGlobal
