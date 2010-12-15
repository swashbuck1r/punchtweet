var ebcdicTable = {
  'a' : [1, 10, 12],
  'b' : [2, 10, 12],
  'c' : [3, 10, 12],
  'd' : [4, 10, 12],
  'e' : [5, 10, 12],
  'f' : [6, 10, 12],
  'g' : [7, 10, 12],
  'h' : [8, 10, 12],
  'i' : [9, 10, 12],
  
  'j' : [1, 11, 12],
  'k' : [2, 11, 12],
  'l' : [3, 11, 12],
  'm' : [4, 11, 12],
  'n' : [5, 11, 12],
  'o' : [6, 11, 12],
  'p' : [7, 11, 12],
  'q' : [8, 11, 12],
  'r' : [9, 11, 12],
  
  's' : [2, 10, 11],
  't' : [3, 10, 11],
  'u' : [4, 10, 11],
  'v' : [5, 10, 11],
  'w' : [6, 10, 11],
  'x' : [7, 10, 11],
  'y' : [8, 10, 11],
  'z' : [9, 10, 11],
  
  'A' : [1, 12],
  'B' : [2, 12],
  'C' : [3, 12],
  'D' : [4, 12],
  'E' : [5, 12],
  'F' : [6, 12],
  'G' : [7, 12],
  'H' : [8, 12],
  'I' : [9, 12],
  
  'J' : [1, 11],
  'K' : [2, 11],
  'L' : [3, 11],
  'M' : [4, 11],
  'N' : [5, 11],
  'O' : [6, 11],
  'P' : [7, 11],
  'Q' : [8, 11],
  'R' : [9, 11],
  
  'S' : [2, 10],
  'T' : [3, 10],
  'U' : [4, 10],
  'V' : [5, 10],
  'W' : [6, 10],
  'X' : [7, 10],
  'Y' : [8, 10],
  'Z' : [9, 10],
  
  '0' : [10],
  '1' : [1],
  '2' : [2],
  '3' : [3],
  '4' : [4],
  '5' : [5],
  '6' : [6],
  '7' : [7],
  '8' : [8],
  '9' : [9],
  
  '¢' : [2,8,12],
  '.' : [3,8,12],
  '<' : [4,8,12],
  '(' : [5,8,12],
  '+' : [6,8,12],
  '|' : [7,8,12],
  
  '!' : [2,8,11],
  '$' : [3,8,11],
  '*' : [4,8,11],
  ')' : [5,8,11],
  ';' : [6,8,11],
  'Â' : [7,8,11],

  ',' : [3,8,10],
  '%' : [4,8,10],
  '_' : [5,8,10],
  '>' : [6,8,10],
  '?' : [7,8,10],
  
  ':' : [2,8],
  '#' : [3,8],
  '@' : [4,8],
  '\'' : [5,8],
  '=' : [6,8],
  '"' : [7,8]
}

var Encoding = Class.create({
  initialize: function(table) {
    this.table = table;
  },

  getRows: function(ch){
    return this.table[ch]
  }
});

var PunchCardMachine = Class.create({
  initialize: function(encoding, display) {
    this.encoding = encoding;
    this.display = display;
    this.col = 81;
  },
  
  add : function(str) {
    for (i = 0; i < str.length; i++) {
      var ch = str.charAt(i);
      this.addChar(ch);
    }
  },
  
  addChar : function(ch) {
    if(this.col == 81){
      this.nextCard();
    }
    this.display.punchCol(this.col++, this.encoding.getRows(ch));
  },
  
  nextCard : function() {
    this.col = 1;
    this.display.next();
  }
});

var PunchcardDisplay = Class.create({
  next : function() {},
  punchCol : function(col, rows) {}
});

var DivPunchcardDisplay = Class.create(PunchcardDisplay, {
  initialize: function(element, cellHeight, cellWidth, colTuner) {
    this.element = element;
    this.cellHeight = cellHeight;
    this.cellWidth = cellWidth;
    this.colTuner = colTuner;
    if(this.colTuner ==  null)
      this.colTuner = function(col) { return col; }
    this.grid = null;
  },
  
  next : function() {
    var punchcard = document.createElement("div");
    punchcard.className = "punchcard";
    this.grid = document.createElement("div");
    this.grid.className = "grid";
    punchcard.appendChild(this.grid);
    this.element.appendChild(punchcard);
  },
  
  punchCol : function(col, rows) {
    if(rows == undefined)
      return;
    for(var i=0; i<rows.length; i++){
      this.punchHole(col, rows[i]);
    }
  },
  
  punchHole : function(col, row) {
    if(this.grid == null)
      this.next()
      
    var punchhole = document.createElement("div");
    punchhole.className = "punchhole";
    var dispCol = col-1;
    var dispRow;
    if(row < 10)
      dispRow = row + 2;
    else if(row == 10)
      dispRow = 2;
    else if(row == 11)
      dispRow = 1;
    else if(row == 12)
      dispRow = 0;
    else
      alert("Unsupported row: " + row);
      
    
    var xOffset = dispCol*this.cellWidth + this.colTuner(dispCol+1);
    var yOffset = dispRow*this.cellHeight;
    var topStyle = "top: " + yOffset + "px;"
    var leftStyle = "left: " + xOffset + "px;"
    punchhole.setAttribute("style", topStyle + leftStyle);
    this.grid.appendChild(punchhole);
  },
  
  clear : function() {
    $$('.punchcard').each(function(e){
      e.remove();
    });
  }
});


