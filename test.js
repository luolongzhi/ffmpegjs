var ffmpeg = require("./ffmpeg.js");
var fs = require("fs");

//var testData = new Uint8Array(fs.readFileSync("pm.wav"));
//var result = ffmpeg({
  //MEMFS: [{name: "pm.wav", data: testData}],
  //arguments: ["-i", "pm.wav", "-f", "mp3", "pm.mp3"],
  //stdin: function() {},
//});
//var out = result.MEMFS[0];
//fs.writeFileSync(out.name, Buffer(out.data));


ffmpeg({
  // Mount /data inside application to the current directory.
  mounts: [{type: "NODEFS", opts: {root: "."}, mountpoint: "/data"}],
  //arguments: ["-i", "/data/test.webm", "-c:v", "libvpx", "-an", "/data/out.webm"],
  arguments: ["-i", "/data/pm.wav", "-f", "mp3", "/data/pm.mp3"],
  //arguments: ["-i", "/data/pm.wav", "-c:a", "libfdk_aac", "-profile:a", "aac_he_v2", "-b:a", "24k", "-f", "adts", "/data/pm.aac"],
  //arguments: ["-i", "http://upos-hz-mirrorwcsu.acgvideo.com/upgcxcode/11/97/10959711/10959711-1-208.mp4?ua=tvproj&deadline=1543204884&gen=playurl&nbs=1&oi=2501663261&os=wcsu&platform=tvproj&trid=1b0c7d985e3244d0aa9f17a8979267bb&uipk=5&upsig=cf3afa552351bad66c2e9fef1f191a17&sparams=ua,deadline,gen,nbs,oi,os,platform,trid,uipk", "-f", "mp3", "/data/hehe.mp3"],
  //arguments: ["-i", "/data/1.mp4", "-f", "mp3", "/data/1.mp3"],
  stdin: function() {},
});


