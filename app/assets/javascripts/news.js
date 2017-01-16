// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function() {

document.addEventListener('keypress', function(event) {
  if (event.charCode == 106 /* j */) {
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
  } else if (event.charCode == 107 /* k */) {
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
});

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
