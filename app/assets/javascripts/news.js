// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function() {

$(document).on('touchend click', '.post-prev', prevArticle);
$(document).on('touchend click', '.post-next', nextArticle);

document.addEventListener('keypress', function(event) {
  if (event.charCode == 106 /* j */) {
    nextArticle();
  } else if (event.charCode == 107 /* k */) {
    prevArticle();
  }
});

function nextArticle() {
  var currentArticle = getCurrentArticle();
  if (currentArticle != null) {
    var nextArticle = currentArticle.nextSibling;
    while (nextArticle != null && nextArticle.tagName != 'ARTICLE') {
      nextArticle = nextArticle.nextSibling;
    }
    if (nextArticle != null) {
      nextArticle.scrollIntoView();
    }
  }
}

function prevArticle() {
  var currentArticle = getCurrentArticle();
  if (currentArticle != null) {
    var prevArticle = currentArticle.previousSibling;
    while (prevArticle != null && prevArticle.tagName != 'ARTICLE') {
      prevArticle = prevArticle.previousSibling;
    }
    if (prevArticle != null) {
      prevArticle.scrollIntoView();
    }
  }
}

function getCurrentArticle() {
  var articles = document.getElementsByTagName('article');
  var scrollPos = document.scrollingElement.scrollTop + 22;
  for (var i = 0; i < articles.length; i++) {
    var articleEnd = articles[i].offsetTop + articles[i].offsetHeight;
    if (scrollPos < articleEnd) {
      return articles[i];
    }
  }
  return null;
}

})();
