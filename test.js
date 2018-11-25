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
  //arguments: ["-i", "/data/pm.wav", "-f", "mp3", "/data/pm.mp3"],
  //arguments: ["-i", "/data/pm.wav", "-c:a", "libfdk_aac", "-profile:a", "aac_he_v2", "-b:a", "24k", "-f", "adts", "/data/pm.aac"],
  arguments: ["-i", "/data/1.mp4", "-f", "mp3", "/data/1.mp3"],
  stdin: function() {},
});


