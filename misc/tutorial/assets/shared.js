(function($) {
  $(function() {
    var $spanCopy = $('span.copy');
    //var serverUrlPlaceholder='__SERVER_URL__';
    //$spanCopy.text($spanCopy.text().replace(
    //  "__SERVER_URL__", location.protocol + '//' + location.hostname + ':' + location.port));
    $spanCopy.click(function(event) {
      event.preventDefault();
      var $this = $(this);
      var s = window.getSelection();
      s.removeAllRanges();
      var r = document.createRange();
      r.selectNode(this);
      s.addRange(r);
      var sSelected = s.toString();
      var copyEvent = new ClipboardEvent('copy', {
        dataType: 'text/plain',
        data: sSelected
      });
      document.dispatchEvent(copyEvent);
      document.execCommand('copy');
      var $copiedNode = $('<div style="top: 50%; ' + 'margin-top: -10px; ' + 'padding: 10px; ' + 'opacity: .8; left: 50%; ' + 'display: none; margin-left: -100px; ' + 'position: fixed; color: #fff; ' + 'background-color: #000; ' + 'border-radius: 10px;">' + '您已经复制了： '
                          + sSelected
                          + '</div>');
      $('body').append($copiedNode)
      $copiedNode.show(500);
      setTimeout(function() {
        $copiedNode.hide(500)
      }, 3000);
    })
  })
})(jQuery)
