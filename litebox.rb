# litebox.rb v.1.0.0
#
#   Options
#     @options['litebox.url'] = string
#       example:
#         @options['litebox.url'] = '/litebox/'
#
#     @options['litebox.resizeSpeed'] = integer
#       controls the speed of the image resizing (1=slowest and 10=fastest)
#
#     @options['litebox.borderSize']  = integer
#       if you adjust the padding in the CSS, you will need to update this variable
#
# Copyright (c) 2007 HASHIMOTO Keisuke <ksk.hashi@gmail.com>
# You can redistribute it and/or modify it under GPL2.

if /(index|update)\.(cgi|rb)$/ =~ $0 then
	@litebox_url  = @conf['litebox.url']
	@litebox_url  = './litebox/' if @litebox_url == nil
	@litebox_url += '/' if %r!/$! !~ @litebox_url
	
	add_header_proc do
		<<-HTML
			<link rel="stylesheet" href="#{h @litebox_url}css/lightbox.css" type="text/css" media="screen">
			<script type="text/javascript" src="#{h @litebox_url}js/prototype.lite.js"></script>
			<script type="text/javascript" src="#{h @litebox_url}js/moo.fx.js"></script>
			<script type="text/javascript" src="#{h @litebox_url}js/litebox.js"></script>
		HTML
	end
	
	add_footer_proc do
		str = <<-END_HTML
			<script type="text/javascript">
			<!--
			(function(){
				var anchors = document.getElementsByTagName( 'a' );
				
				for ( var i = 0; i < anchors.length; i++ ){
					var anchor = anchors[i];
					var rel    = anchor.getAttribute( 'rel' );
					var href   = anchor.getAttribute( 'href' );
					
					if( ( rel == null || rel == '' ) && href && href.match( /\\.(?:jpe?g|gif|png)$/i ) ) {
						rel = 'lightbox';
						
						if( href.match( /\\/(\\d{8})_\\d+\\.\\w+$/i ) ) {
							rel += '[' + RegExp.$1 + ']';
							
							var imgs = anchor.getElementsByTagName( 'img' );
							for( var j = 0; j < imgs.length; ++j ) {
								var title = imgs[j].getAttribute( 'title' );
								
								if( title != null ) {
									anchor.setAttribute( 'title', title );
									break;
								}
							}
						}
						
						anchor.setAttribute( 'rel', rel );
					}
				}
			})();
			
			fileLoadingImage = '#{h @litebox_url}images/loading.gif';
			fileBottomNavCloseImage = '#{h @litebox_url}images/closelabel.gif';
		END_HTML
		
		if @conf['litebox.resizeSpeed'] != nil then
			str += "resizeSpeed = #{h @conf['litebox.resizeSpeed']};\n"
		end
		
		if @conf['litebox.borderSize'] != nil then
			str += "borderSize = #{h @conf['litebox.borderSize']};\n"
		end
		
		str + <<-END_HTML
			initLightbox();
			// -->
			</script>
		END_HTML
	end
end
