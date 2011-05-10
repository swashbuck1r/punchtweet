    <html>
  <head>
    <title>PunchTweet - tweeting it old school!</title>
    <script src="scripts/prototype.js" type="text/javascript" ></script>
    <script src="scripts/punchcard.js" type="text/javascript" ></script>
    <script type="text/javascript" charset="utf-8" src="http://bit.ly/javascript-api.js?version=latest&login=swashbuck1r&apiKey=R_515bb2e8cfca31c7e8e0984910b59faf"></script>
    <script src="http://widgets.digg.com/buttons.js" type="text/javascript"></script>
    
    <script type="text/javascript">
    Event.observe(window, 'load', function() {
      var encoding = new Encoding(ebcdicTable);
      
      //the card isn't a perfect grid, so this function tunes the grid cell locations a bit
      var colTuner = function(col){ return col/2.9 }
      
      var display = new DivPunchcardDisplay($('punchcards'), 36, 12, colTuner);
      var punchcard = new PunchCardMachine(encoding, display);
      var url = window.location.search.substring(1);
      var params = url.toQueryParams();
      var tweet = params['t'];
      var encoded = params['e'];
      if(tweet == null && encoded != null){
        tweet = "";
        for(var i=0; i<encoded.length; i++)
          tweet += String.fromCharCode(encoded.charCodeAt(i) - 1);
      }
      if(tweet != null){
        $('input').setValue(tweet);
      }
      
      punchcard.nextCard();
      refresh();
      
      $('input').observe("keyup", keyDown);
      $('retweet').observe("click", function(event){
        Event.stop(event);
        return tweetMe("#punchtweet ", createUrl());
      });
      
      $('genurl').observe("click", function(event){
        Event.stop(event);
        return window.location = createUrl();
      });
      
      function keyDown(event) {
        display.clear();
        punchcard.nextCard();
        refresh();
      }
      
      function refresh(){
        var text = $F('input');
        var charsLeft = 80 - text.length;
        var lengthMessage = charsLeft < 0 ? "cards are stackable, so keep on typing..." : charsLeft + "";
        $('charlimit').update(lengthMessage);
        punchcard.add($F('input'));
      }
      
      function createUrl(){
        var text = $F('input');
        var encoded = "";
        for(var i=0; i<text.length; i++)
          encoded += String.fromCharCode(text.charCodeAt(i) + 1);
        return "http://punchtweet.spike13.cloudbees.net/?e=" + encoded;
      }
    });
    
    function tweetMe(msg, url) {
      var textMessage = msg.replace(new RegExp("^(.{0," + 80 + "}\\b).*"), "$1");
      var callback_name = url.replace(/\W/g, '');
      BitlyCB[callback_name] = function(data) {
        var result = TweetAndTrack.popResult(data);
        var tweet_url = "http://twitter.com/home?status=" + encodeURIComponent(textMessage+ "... " + result.shortUrl );
        window.location=tweet_url;
      };
       
      BitlyClient.call('shorten', {
      'longUrl': url,
      'history': '1'
      }, 'BitlyCB.' + callback_name);
       
      return false;
    }
    
    var TweetAndTrack = {};
      TweetAndTrack.open = function(targ, url) {
        var callback_name = url.replace(/\W/g, '');
        BitlyClient.call('shorten', {
          'longUrl': url,
          'history': '1'
        }, 'BitlyCB.' + callback_name);
        return false;
      };
       
      TweetAndTrack.popResult = function(data) {
      // Results are keyed by longUrl, so we need to grab the first one.
      for (var r in data.results) {
        return data.results[r];
      }
    };
    </script>
    
    <style>
      .punchcard { 
        position: relative;
        background:#ffffff url('http://stax-downloads.s3.amazonaws.com/files/punchcard-blank-EBCDIC.jpg') no-repeat right top;
        height: 476px;
        width: 1056px;
      }
      
      .punchcard .grid {
        position: absolute;
        top: 20px; left: 33px;
        height: 427px;
        width: 990px;
      }
      
      .punchhole {
        height: 21px;
        width: 6px;
        margin: 5px 3px 8px 2px;
        background: url('http://stax-downloads.s3.amazonaws.com/files/punchhole.gif') no-repeat right top;
        position: absolute;
      }
      
      #punchbox {
        position: relative;
        width: 1020px;
        margin: 0px 0px 10px 20px;
        height: 148px;
      }
      
      h1 { margin: 0px 0px 5px 0px; font-size: 18px;}
      
      textarea { 
        height: 60px; width: 1020px; 
        font-size: 21px;
        font-family:Courier New,monospace;
        margin-bottom: 5px;
        border: 1px solid #5C7B98;
      }
      
      #punchbox a.btn { text-decoration: none; }
      #punchbox a.btn span {
        /*position: absolute; right: 0px; bottom: 0px;*/
       float: right;
        background-color: #5C7B98;
        font-size: 14px;
        border: 1px solid #1E3140;
        padding: 4px;
        color: white;
        margin-left: 5px;
      }
      
      #charlimit  { float: right; font-size: 20px; color:#BCBFC4; font-weight: bold; }
      
      #titleBar { margin: 0px 0px 10px 20px; position: relative; width: 1084px; } 
      #titleBar .diggButton { position: absolute; right: 0px;}
    </style>
  </head>
  <body>
    <div id="titleBar">
      <div class="diggButton">
        <a class="DiggThisButton DiggMedium" href="http://digg.com/submit?url=http%3A//punchtweet.spike13.cloudbees.net/"></a>
      </div>
      <p>Punchcards are the original TWEETS (just limited to 80 chars instead of 140)</p>
    </div>
    <div id="punchbox">
      <span id="charlimit"></span><h1>Punch something...</h1>
      <textarea id="input"></textarea>
      <a id="retweet" class="btn" href="http://punchtweet.spike13.cloudbees.net"><span>PunchTweet</span></a>
      <a id="genurl" class="btn" href="http://punchtweet.spike13.cloudbees.net"><span>Link</span></a>
    </div>
    
    <div id="punchcards">
      
    </div>
    
    <div id="stax"><div id="icon"></div>Got an idea for an app of your own? Punchcards run at cloud scale on <a href="http://www.cloudbees.com">CloudBees</a> &nbsp;&nbsp;&nbsp;...it's great for all Java apps on EC2 (not just punching cards)</div>
  
  <script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15625543-1");
pageTracker._trackPageview();
} catch(err) {}</script>
  </body>
</html>
