const express = require('express')
const app = express()

const fs =require('fs');
var buffer = require('buffer')
var multer  = require('multer')
var upload = multer({ dest: 'uploads/' })
var ipfsAPI = require('ipfs-api')
var ipfs = ipfsAPI('ipfs.infura.io', '5001', {protocol: 'https'})
 
 
app.get('/', function (req, res) {
//   res.send('Hello World')
    res.sendFile(__dirname+'/public/index.html');
})

app.post('/upload', upload.single('avatar'), function (req, res, next) {
 res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    // req.file is the `avatar` file
    // req.body will hold the text fields, if there were any
	console.log("\n");
    console.log(req.file);
    var data = new buffer.Buffer.from(fs.readFileSync(req.file.path));//bez byteLength
    ipfs.add(data, function (err,file){
        if(err){
            console.log(err);
        }
        console.log(file);
        res.send(file[0].hash);
    })
    console.log('\n');
  })

  app.get('/download/:ID',function(req,res){
      console.log(req.params.ID);
      res.redirect('https://ipfs.io/ipfs/'+req.params.ID);
  })
  
  app.listen(3000, () => {
    console.log("Server is listening on port 3000\n");
  });