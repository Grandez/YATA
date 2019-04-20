
//tags$script(
// "$('#shinytheme-selector')
//   .on('change', function(el) {
    // var allThemes = $(this).find('option').map(function() {
//       if ($(this).val() === 'default')
//         return 'bootstrap';
//       else
//         return $(this).val();
//     });
//     // Find the current theme
//     var curTheme = el.target.value;
//     if (curTheme === 'default') {
//       curTheme = 'bootstrap';
//       curThemePath = 'shared/bootstrap/css/bootstrap.min.css';
//     } else {
//       curThemePath = 'shinythemes/css/' + curTheme + '.min.css';
//     }
//     // Find the <link> element with that has the bootstrap.css
//     var $link = $('link').filter(function() {
//       var theme = $(this).attr('href');
//       theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');
//       return $.inArray(theme, allThemes) !== -1;
//     });
//     // Set it to the correct path
//     $link.attr('href', curThemePath);
//   });"
//     )
// )

// Shiny.addCustomMessageHandler("handler1", function(params) {document.getElementById("btnNext").click();}); 

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
 
function YATAPanels(ns) {
    left  = document.getElementById(ns + "left");
    right = document.getElementById(ns + "right");
    
    YATAIconBar("left",  0);
    YATAIconBar("right", 0);
    if (left)  {
        left.classList.toggle("shinyjs-hide");
        YATAIconBar("left", 1);
        document.getElementById("YATALeftSide").appendChild(left);
    }
    if (right) {
        right.classList.toggle("shinyjs-hide");
        YATAIconBar("right", 1);
        document.getElementById("YATARightSide").appendChild(right);
    }
} 

// Muestra/Oculta el panel correspondiente
// side: 0 -> left, 1 -> right
/*
function YATAIconNavJS(side) {
    var ns = document.getElementById("nsPreffix").value;
    
    var divSfx = (side === 0) ? "-left": "-right";
    var divName = ns + divSfx;
    var clsOld = "col-sm-10";
    var clsNew = "col-sm-12";
    var idDiv = document.getElementById(divName);
    var idMain = document.getElementById(ns + "-main");
    
    cls = idMain.classList;
    
    var vis = (idDiv.style.display.length === 0) ? true : false;
    // Si es visible, main sera 8 o 10
    if (vis) {
        document.getElementById(divName).style.display = "none";
        clsOld = "col-sm-8";
        clsNew = "col-sm-10";
        if (cls.contains("col-sm-10")) {
            clsOld = "col-sm-10";
            clsNew = "col-sm-12";
        }
    }
    else {
        document.getElementById(divName).style.removeProperty("display");
        clsOld = "col-sm-12";
        clsNew = "col-sm-10";
        if (cls.contains("col-sm-10")) {
            clsOld = "col-sm-10";
            clsNew = "col-sm-8";
        }
    }
    document.getElementById(ns + "-main").classList.replace(clsOld, clsNew);
    // alert("Cambia: " + clsOld + " a "  + clsNew);
}
*/
// Muestra y Oculta el div asociado de la barra



/*
function toggleSideBar(divShow, divHide) {
    //alert("Entra en la funcion");
    document.getElementById(divShow).style.removeProperty("display");
    document.getElementById(divHide).style.display = "none";
}
function toggleLabel(divName) {
    box = document.getElementById(divName).getElementsByClassName("box-header");
    box1 = box[0];
    lbl = box1.getElementsByClassName("label")[0];
    var vis = (lbl.style.display.length === 0) ? true : false;
    if (vis) {
        lbl.style.display = "none";
    }
    else {
        lbl.style.removeProperty("display");
    }
}
*/