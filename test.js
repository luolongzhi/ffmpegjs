//var ffmpeg = require("./ffmpeg.js");
var ffmpeg = require("./ffmpegaudio.js");
var fs = require("fs");

ffmpeg({
  // Mount /data inside application to the current directory.
  mounts: [{type: "NODEFS", opts: {root: "./tmpaudio"}, mountpoint: "/data"}],
  //arguments: ["-i", "/data/test.webm", "-c:v", "libvpx", "-an", "/data/out.webm"],
  //arguments: ["-i", "/data/pm.wav", "-f", "mp3", "/data/pm.mp3"],
  //arguments: ["-y", "-i", "/data/pm.wav", "-c:a", "libfdk_aac", "-profile:a", "aac_he_v2", "-b:a", "24k", "-f", "adts", "/data/pm1.aac"],
  //arguments: ["-y", "-i", "/data/pm.wav", "-acodec", "wmav2", "/data/pm1.wma"],
  //arguments: ["-y", "-i", "/data/pm.wav", "-acodec", "wmav2", "/data/pm1.wma"],
  arguments: ["-y", "-i", "/data/pm.wav", "-acodec", "vorbisenc", "-f", "ogg", "/data/pm1.ogg"],
  //arguments: ["-y", "-i", "/data/pm.wav", "-f", "flac", "/data/pm1.flac"],
  //arguments: ["-i", "http://upos-hz-mirrorwcsu.acgvideo.com/upgcxcode/11/97/10959711/10959711-1-208.mp4?ua=tvproj&deadline=1543204884&gen=playurl&nbs=1&oi=2501663261&os=wcsu&platform=tvproj&trid=1b0c7d985e3244d0aa9f17a8979267bb&uipk=5&upsig=cf3afa552351bad66c2e9fef1f191a17&sparams=ua,deadline,gen,nbs,oi,os,platform,trid,uipk", "-f", "mp3", "/data/hehe.mp3"],
  //arguments: ["-y", "-i", "/data/1.mp4", "-f", "mp3", "/data/1.mp3"],
  stdin: function() {},
});


