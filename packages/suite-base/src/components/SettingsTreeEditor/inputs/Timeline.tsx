import { Slider } from "@mui/material";
import { useCallback, MouseEvent, useState, useEffect } from "react";
import { makeStyles } from "tss-react/mui";

import PlayCircleIcon from "@mui/icons-material/PlayCircle";
import PauseCircleIcon from '@mui/icons-material/PauseCircle';

import { useStyles } from "@lichtblick/suite-base/components/SettingsTreeEditor/FieldEditor.style";

type TimelineProps = {
  onChange: (value: undefined | number) => void;
  step?: number;
  value: undefined | number;
  min?: number;
  max?: number;
  playbackSpeed?: number;
};

export function Timeline(props: TimelineProps): React.JSX.Element {
  const { classes, cx } = useStyles();

  const [value, setValue] = useState(props.value ?? 0);
  const [isPlaying, setIsPlaying] = useState(false);

  let intervalRef: ReturnType<typeof setTimeout> | undefined = undefined;

  useEffect(() => {
    if (isPlaying) {
      intervalRef = setInterval(() => {
        setValue(prev => prev + (props.step ?? 1));
      }, 1000 / (props.playbackSpeed ?? 1))
    } else {
      clearInterval(intervalRef);
    }

    return () => {
      if (intervalRef) {
        clearInterval(intervalRef);
      };
    };
  }, [isPlaying]);

  useEffect(() => {
    props.onChange(value);
  }, [value]);

  const changeCallback = (_: any, value: undefined | number) => {
    setValue(value ?? 0);
  }

  const togglePlay = () => {
    setIsPlaying(prev => !prev);
  };

  return (
    <div style = {{ display: "flex", }}>
      <button className={classes.playButton} onClick = {togglePlay}>
        {isPlaying ? (
            <PauseCircleIcon fontSize="inherit" />
          ) : (
            <PlayCircleIcon fontSize="inherit" />
          )
        }
      </button>
      <Slider
        className={classes.playSlider}
        value={value}
        min={props.min}
        max={props.max}
        step={props.step}
        size="small"
        valueLabelDisplay="auto"
        onChange={changeCallback}
      />
    </div>
  )
}
