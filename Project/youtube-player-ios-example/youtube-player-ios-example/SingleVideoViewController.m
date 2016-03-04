// Copyright 2014 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SingleVideoViewController.h"

@implementation SingleVideoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *videoId = @"M7lc1UVf-VE";

  // For a full list of player parameters, see the documentation for the HTML5 player
  // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
  NSDictionary *playerVars = @{
      @"controls" : @0,
      @"playsinline" : @1,
      @"autohide" : @1,
      @"showinfo" : @0,
      @"modestbranding" : @1,
      @"autoplay" : @0
  };
  self.playerView.delegate = self;
  [self.playerView loadWithVideoId:videoId playerVars:playerVars];
}

- (void)playerView:(YTPlayerView *)ytPlayerView didChangeToState:(YTPlayerState)state {
  NSString *message = [NSString stringWithFormat:@"Player state changed: %ld\n", (long)state];
  [self appendStatusText:message];
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    if (self.slider.touchInside || (self.playerView.duration <= 0)) {
        return;
    }
    
    float progress = playTime/self.playerView.duration;
    [self.slider setValue:progress];
}

- (IBAction)onSliderChange:(id)sender {
    float seekToTime = self.playerView.duration * self.slider.value;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
    [self appendStatusText:[NSString stringWithFormat:@"Seeking to time: %.0f seconds\n", seekToTime]];
}

- (IBAction)buttonPressed:(id)sender {
  if (sender == self.playButton) {
    [self.playerView playVideo];
  } else if (sender == self.stopButton) {
    [self.playerView stopVideo];
  } else if (sender == self.pauseButton) {
    [self.playerView pauseVideo];
  } else if (sender == self.reverseButton) {
    float seekToTime = self.playerView.currentTime - 30.0;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
    [self appendStatusText:[NSString stringWithFormat:@"Seeking to time: %.0f seconds\n", seekToTime]];
  } else if (sender == self.forwardButton) {
    float seekToTime = self.playerView.currentTime + 30.0;
    [self.playerView seekToSeconds:seekToTime allowSeekAhead:YES];
    [self appendStatusText:[NSString stringWithFormat:@"Seeking to time: %.0f seconds\n", seekToTime]];
  } else if (sender == self.startButton) {
    [self.playerView seekToSeconds:0 allowSeekAhead:YES];
    [self appendStatusText:@"Seeking to beginning\n"];
  }
}

/**
 * Private helper method to add player status in statusTextView and scroll view automatically.
 *
 * @param status a string describing current player state
 */
- (void)appendStatusText:(NSString *)status {
  [self.statusTextView setText:[self.statusTextView.text stringByAppendingString:status]];
  NSRange range = NSMakeRange(self.statusTextView.text.length - 1, 1);

  // To avoid dizzying scrolling on appending latest status.
  self.statusTextView.scrollEnabled = NO;
  [self.statusTextView scrollRangeToVisible:range];
  self.statusTextView.scrollEnabled = YES;
}

@end
