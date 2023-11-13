function setFavicons(favImg){
    let headTitle = document.querySelector('head');
    let setFavicon = document.createElement('link');
    setFavicon.setAttribute('rel','shortcut icon');
    setFavicon.setAttribute('href',favImg);
    headTitle.appendChild(setFavicon);
}
setFavicons('http://doollee.co.kr/resrc/image/favicon.png');

function includeHTML(callback) {
	var z, i, elmnt, file, xhr;
	/*loop through a collection of all HTML elements:*/
	z = document.getElementsByTagName('*');
	for (i = 0; i < z.length; i++) {
		elmnt = z[i];
		/*search for elements with a certain atrribute:*/
		file = elmnt.getAttribute('include-html');
		//console.log(file);
		if (file) {
			/*make an HTTP request using the attribute value as the file name:*/
			xhr = new XMLHttpRequest();
			xhr.onreadystatechange = function() {
				if (this.readyState == 4) {
					if (this.status == 200) {elmnt.innerHTML = this.responseText;}
					if (this.status == 404) {elmnt.innerHTML = 'Page not found.';}
					/*remove the attribute, and call this function once more:*/
					elmnt.removeAttribute('include-html');
					includeHTML(callback);
				}
			}      
			xhr.open('GET', file, true);
			xhr.send();
			/*exit the function:*/
		 return;
		}
	}
	setTimeout(function() {
		if(callback != undefined) callback();
		if($('.gnbmenu').length > 0) gnbmenuEvent();
	}, 0);
	

    // 내용의 전체 적용 방지 위해 함수로 생성 후 아래에서 호출.  필요하면 조건 추가 후 사용
    if( location.pathname.indexOf("/Doollee_holi_main") == 0 || location.pathname.indexOf("/Doollee_prod_main") == 0 ) {
        //message popup div create
        $("html").append(
            '<div class="messagePop"><div>' +
            '    <div><div class="content scrollCat"></div></div>' +
            '    <div class="buttonArea"><label>취소</label><label>확인</label></div>' +
            '</div></div>'
        );
        //loding popup div create
        $("html").append('<div class="loadingDiv"><div><div></div><div></div><div></div></div></div>');
    	
        designMessge (); //alert > design layer로 대체
        initSelectbox(); //select box
        loadingInit  (); //ajax loading bar
    }
};

function gnbmenuEvent(){
	$('.m-btn').on('click', function(){
		 $('.gnbmenu').fadeIn(300, function(){
			$('.gnbmenu .gnb').addClass('on');
			$('body, html').css('overflow','hidden');
		 });
	});
	$('.gnbmenu .close, .gnbmenu .mask').on('click', function(){
		$('.gnbmenu .gnb').removeClass('on');
		 $('.gnbmenu').fadeOut(300);
		 $('body, html').css('overflow','');
	});

	addMore();
	$('.gnbmenu .menu > li > a').on('click', function(){
		if($(this).next('ul').is(':hidden')){
			$(this).parent('li').addClass('open');
			$(this).next('ul').slideDown();
		}else{
			$(this).parent('li').removeClass('open');
			$(this).next('ul').slideUp();
		}
	});

	function addMore(){
		$('.gnbmenu .menu > li > ul > li').parents('li').addClass('more');
	}

	gnbmenuLayer();
	function gnbmenuLayer(){
		var gnbmenu = $('.gnbmenu .menu').clone();
		$('.gnbmenu-layer .wrapper').append(gnbmenu);
	}

	var toggling = false;
	function slidein(){
		 $('.gnbmenu-layer').stop().slideDown();
	}
	function slideout(){
		 $('.gnbmenu-layer').stop().slideUp();
		 $('.gnbmenu .menu li').removeClass('on');
	}

	$('.gnbmenu, .gnbmenu-layer').on('mouseenter', function(){
		clearTimeout(toggling);
		 toggling = setTimeout(slidein, 300);
	});


	$('.gnbmenu, .gnbmenu-layer').on('mouseleave', function(){
		clearTimeout(toggling);
		toggling = setTimeout(slideout, 300);
	});

	$('.gnbmenu-layer .menu > li').on('mouseenter', function(){
		var index = $(this).index();
		$('.gnbmenu .menu > li').removeClass('on');
		$('.gnbmenu .menu > li').eq(index).addClass('on');
	});

	$('.gnbmenu-layer .menu > li').on('mouseleave', function(){
		$('.gnbmenu .menu > li').removeClass('on');
	});

	$(window).resize(function(){
		$('.gnbmenu li').removeClass('on');
		$('.gnbmenu li ul').hide();
		$('.gnbmenu-layer').attr('style', '');
		if($(window).width() < 1199){
			$('.gnbmenu').hide();
		}
	});
}

function tabMenu(){
	// tabType1
	$('.tab-type1 li').on('click', function(){
		var $this = $(this);
		var $siblings = $(this).siblings();
		var $parent = $(this).parents('.tab-type1');
		var val = $(this).text();

				$siblings.removeClass('on');
				$this.addClass('on');
				$parent.removeClass('on');
				$parent.find('.selected').find('span').text(val);
	});

	$('.tab-type1 .selected').on('click', function(){
		var $parent = $(this).parents('.tab-type1');
		if(!$parent.hasClass('on')) $parent.addClass('on');
		else $parent.removeClass('on');
	});
}

/** 2023-06-13 임영록 추가 */
//모바일여부(Android/IOS 구분) 조회
var isMobile = function() {
    var rtnCode = "Local" ;
    //Android check
    try { if( window.Android ) {rtnCode = "Android";} } catch(e) { }
    //IOS check
    try { if( window.webkit  ) {rtnCode = "IOS";    } } catch(e) { }
    return rtnCode ;
}
//디바이스 정보 받기
window["deviceInfo"] = {};
var deviceInfoCallBack = function( inDataApp ) { window["deviceInfo"] = JSON.parse( inDataApp ); }
if( isMobile() == "Android" ) Android.getDeviceInfo("deviceInfoCallBack");
if( isMobile() == "IOS"     ) webkit.messageHandlers.getDeviceInfo.postMessage("deviceInfoCallBack");
if( isMobile() == "Local"   ) window["deviceInfo"]["device_model"] = "";
//ajax 사용시 로딩바 실행 추가
function loadingInit() {
    //ajax 전후 공용처리 (사용안하는 곳에서는 global:false 옵션 추가, loadingDiv를 ajax이외 사용시 내부 내용만 따로 사용)
    $(document).ajaxStart(function () { $(".loadingDiv").addClass("show"); });
    $(document).ajaxStop (function () { setTimeout( function() { $(".loadingDiv").removeClass("show"); }, 1000); });
}
//alert을 message layer popup으로 변경 (함수 사용 후 기존 alert사용시 alert('내용', 'debug'))
function designMessge() {
    var originMessagePop = "" ;
    var messagePopArr    = ["alert", "confirm"] ;
    var messagePopRtnFun = "" ;
    $.each(messagePopArr, function(key, val) {
        var originMessagePop = window[ val ] ;
        window[ val ] = function(in_cont, option) {
            if( option == "debug" ) originMessagePop( in_cont );
            else {
                $(".messagePop .content").html( in_cont );
                $(".messagePop").addClass( val );
                messagePopRtnFun = "";
                if( typeof option === "function" ) {
                    messagePopRtnFun = option ;
                }
                setTimeout( function() { $(".messagePop > div").css("top", "50%"); }, 1 );
    
                if( window["deviceInfo"]["device_model"].indexOf("iPhone 6 ") > -1 ) {
                    $('label').click(function() {}); //구 IOS lavel Click Event 전 호출
                }
            }
        }
    });
    //message popup button click
    $(document).off("click", ".messagePop .buttonArea label");
    $(document).on ("click", ".messagePop .buttonArea label", function() {
        var obj   = $(this);
        var vFunc = messagePopRtnFun ;
        messagePopRtnFun = "";
        
        $(".messagePop > div").css("top", "");
        setTimeout( function() {
            if( typeof vFunc === "function" ) { vFunc( obj.index()==1 ); }
            $(".messagePop").removeClass("alert").removeClass("confirm");
            $(".messagePop .content").html("");
        }, 500 );
    });
}
// label selectbox
function initSelectbox() {
    //seletbox(div) 설정 Start
    $(document).off("click", ".selectbox-form > input");
    $(document).on ("click", ".selectbox-form > input", function() {
        var obj = $(this).next();
        if( !obj.hasClass("open") ) {
            if( obj.hasClass("selmode-popup") ) {
                obj.css("width", "80%").css("height", (obj.find("ul").prop("scrollHeight") + 50) +"px");
            } else {
                obj.css("width", $(this).outerWidth()+"px").css("height", obj.find("ul").outerHeight()+"px");
            }
            if( obj.find("input[type=checkbox]").length == 0 ) {
                obj.find("li"                             ).removeClass("selected");
                obj.find("li[value='"+ $(this).val() +"']").addClass   ("selected");
            } else {
                obj.find("input[type=checkbox]:checked").prop("checked", false);
                
                var codeArr = $(this).val() ? $(this).val().split(",") : "" ;
                var ckAllYn = codeArr.length == obj.find("li").not(".all-select").length || codeArr.length == 0 ;
                obj.find("li.all-select").find("input[type=checkbox]").prop("checked", ckAllYn );
                if( ckAllYn ) obj.find("input[type=checkbox]").prop("checked", true);
                else {
                	$.each( codeArr , function(idx, value) {
                        obj.find("li[value='"+ value +"']").find("input[type=checkbox]").prop("checked", true);
                    });
                }
            }
            $(this).parents(".selectbox-form").append("<span class='selectbox-dim-layer'></span>");
            
            $("html").append("<div id='dummyDim' style='position:fixed;left:0;top:0;width:100%;height:100%;z-index:1200'></div>");
            setTimeout( function() {
                obj.addClass("open");
                setTimeout( function() { $("#dummyDim").remove(); }, 400 );
            }, 50 );
        }
    });
    $(document).off("click", ".selectbox-form > div li");
    $(document).on ("click", ".selectbox-form > div li", function() {
        var obj = $(this);
        if( obj.find("input[type=checkbox]").length == 0 ) {
            obj.parents(".selectbox-form").find(">input").val( obj.attr("value") ).change();
            obj.parent().find("li").removeClass("selected") ;
            obj                    .addClass   ("selected") ;
            setTimeout( function() { $(".selectbox-dim-layer").click(); }, 50 );
        } else {
            if( obj.hasClass("all-select") ) {
                var allSelectChkYn = !obj.find("input[type=checkbox]").prop("checked");
                obj.parent().find("input[type=checkbox]").prop("checked", allSelectChkYn );
            } else {
                obj.find("input[type=checkbox]").prop("checked", !obj.find("input[type=checkbox]").prop("checked") );
                obj.parent().find("li.all-select").find("input[type=checkbox]").prop("checked",
                    obj.parent().find("li").not(".all-select").length ==
                    obj.parent().find("li").not(".all-select").find("input[type=checkbox]:checked").length
                );
            }
        }
    });
    $(document).off("click", ".selectbox-form input[type=checkbox]");
    $(document).on ("click", ".selectbox-form input[type=checkbox]", function(e) {
        var obj = $(this);
    	setTimeout( function() { obj.parent().click(); }, 0 );
    	return false;
    });
    $(document).off("click", ".selectbox-dim-layer");
    $(document).on ("click", ".selectbox-dim-layer", function() {
        $(".selectbox-form > div.open").css("height","0").removeClass("open");
        var chkObj = $(this).parent().find("input[type=checkbox]");
        if( chkObj.length > 0 ) {
            var chkData = new Array("", "");
            chkObj.each( function() {
                if( !$(this).prop("checked") ) return true;
                if( $(this).parent().hasClass("all-select") ) {
                    chkData[0] = $(this).parent().attr("value");
                    chkData[1] = $(this).next  ().text();
                    return false;
                }
                chkData[0] += ( chkData[0] ? "," : "" ) + $(this).parent().attr("value");
                chkData[1] += ( chkData[1] ? "," : "" ) + $(this).next  ().text();
            });
            if( chkData[0] != chkObj.parents(".selectbox-form").find(">input").attr("code") ) {
                chkObj.parents(".selectbox-form").find(">input").attr("code" , chkData[0] );
                chkObj.parents(".selectbox-form").find(">input").attr("value", chkData[1] );
                chkObj.parents(".selectbox-form").find(">input").change();
            }
        }
        $(this).remove();
        return false;
    });
    $(window).resize( function() { if( $(".selectbox-dim-layer").length > 0 ) $(".selectbox-dim-layer").click(); });
    var originValue = $.fn.val ;
    $.fn.val = function( inData ) {
        if( $(this).parent().hasClass("selectbox-form") && $(this).prop("tagName")=="INPUT" ) {
            if( inData || inData=="" ) {
                $(this).attr("code" , inData);
                var inValue = $(this).next().find("li").find("label").length == 0
                            ? $.trim( $(this).next().find("li[value='"+ inData +"']").text() )
                            : $.trim( $(this).next().find("li[value='"+ inData +"']").find("div").text() )
                ;
                inData = inValue ;                
            } else {
                return $(this).attr("code") ? $(this).attr("code") : "" ;
            }
        }
        return typeof inData === "undefined" ? originValue.call(this) : originValue.call(this, inData);
    }
    //seletbox(div) 설정 End
}

function toastMsgCall( cont ) {
    if( $("html > .toastMsgBox").length > 0 ) return;
    $("html").append("<div class='toastMsgBox'>"+ cont +"</div>");
    setTimeout( function() {  $("html > .toastMsgBox").css("bottom", "0"); }, 100 );
    setTimeout( function() {
        $("html > .toastMsgBox").css("bottom", "-80px");
        setTimeout( function() { $("html > .toastMsgBox").remove(); }, 1000 );
    }, 5000 );
}

