/*
 * Muestra/oculta los iconos de los paneles laterales
 */
function YATAIconBar(side, show) {
    el = document.getElementById("YATANav-" + side);
    if (show) {
       el.classList.add("shinyjs-show");
       el.classList.remove("shinyjs-hide");   
    }
    else {
       el.classList.add("shinyjs-hide");
       el.classList.remove("shinyjs-show");   
    }
}

function YATALang() {
  var language =  window.navigator.userLanguage || window.navigator.language;
  Shiny.onInputChange('YATALang', language);
}

/*
 * Muestra/oculta El panel lateral
 */

function YATAToggleSideBar(left, show) {
    var item = "YATAIconNav";
    var side = (left) ? "-left" : "-right";
    var div  = (left) ? "YATALeftSide" : "YATARightSide";
    
    divBase = item + side;
    if (show) {
        document.getElementById(divBase + "-on").style.display = "none";
        document.getElementById(divBase + "-off").style.display = "inline-block";   
    }
    else {
        document.getElementById(divBase + "-on").style.display = "inline-block";   
        document.getElementById(divBase + "-off").style.display = "none"; 
    }
    var element = document.getElementById(div);
    element.classList.toggle("shinyjs-hide");
    element.classList.toggle("shinyjs-show");
}

/*
 * Ajusta los paneles y los iconos
 */ 

function YATAShowHide(panel, child) {
    child.classList.add("shinyjs-show");
    child.classList.remove("shinyjs-hide");   
      
    p = document.getElementById(panel);  
    childs = p.childNodes;

    for (var i = 0; i < childs.length; i++) {
         childs[i].classList.add("shinyjs-hide");
         childs[i].classList.remove("shinyjs-show");   
    }
    p.appendChild(child);
} 
function YATAPanels(ns) {
    left  = document.getElementById(ns + "left");
    right = document.getElementById(ns + "right");
//    modal = document.getElementById(ns + "modal");
    
    YATAIconBar("left",  0);
    YATAIconBar("right", 0);
    if (left)  {
      YATAShowHide("YATALeftSide", left);
      YATAIconBar("left", 1);
    }
    if (right) {
        YATAShowHide("YATARightSide", right);
        YATAIconBar("right", 1);
    }
//    if (modal) {
//      p = document.getElementById("main-container");
//      p.appendChild(modal);
//    }
} 
