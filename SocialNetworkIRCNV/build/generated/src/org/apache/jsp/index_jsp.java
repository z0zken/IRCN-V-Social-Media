package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html>\r\n");
      out.write("    <head>\r\n");
      out.write("        <title>Your Profile</title>\r\n");
      out.write("        <meta charset=\"UTF-8\">\r\n");
      out.write("        <link rel=\"icon\" href=\"/SocialNetworkIRCNV/data/img/logo.jpg\" type=\"image/i-con\">\r\n");
      out.write("        <link rel=\"shortcut icon\" href=\"./images/logo.png\" type=\"image/x-icon\">\r\n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n");
      out.write("        <link href=\"bootstrap-5.0.2-dist/css/bootstrap.min.css\" rel=\"stylesheet\">\r\n");
      out.write("        <script src=\"bootstrap-5.0.2-dist/js/bootstrap.bundle.min.js\"></script> \r\n");
      out.write("        <script src=\"https://code.jquery.com/jquery-3.6.0.min.js\"></script>\r\n");
      out.write("        <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css\"\r\n");
      out.write("              integrity=\"sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==\"\r\n");
      out.write("              crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\" />\r\n");
      out.write("        <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css\">\r\n");
      out.write("        <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js\"></script>\r\n");
      out.write("        <script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js\" integrity=\"sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM\" crossorigin=\"anonymous\"></script>\r\n");
      out.write("        <script src=\"https://kit.fontawesome.com/24c45437f2.js\" crossorigin=\"anonymous\"></script>\r\n");
      out.write("    </head>\r\n");
      out.write("    <body>\r\n");
      out.write("        <button onclick=\"load('CID00000079')\">load</button>\r\n");
      out.write("        <div id=\"myProfile\">\r\n");
      out.write("                    <div class=\"modal\" id = \"modifyModal\" tabindex=\"-1\" role=\"dialog\" style=\"font-size: 15px;\">\r\n");
      out.write("                        <style>\r\n");
      out.write("                            .post-top{\r\n");
      out.write("                                display:flex;\r\n");
      out.write("                                align-items: center;\r\n");
      out.write("                                padding:10px;\r\n");
      out.write("                                padding-bottom: 0;\r\n");
      out.write("                            }\r\n");
      out.write("\r\n");
      out.write("                            .post-top .dp{\r\n");
      out.write("                                width:60px;\r\n");
      out.write("                                height:60px;\r\n");
      out.write("                                border-radius: 50%;\r\n");
      out.write("                                overflow:hidden;\r\n");
      out.write("                            }\r\n");
      out.write("\r\n");
      out.write("                            .post-top .dp > img{\r\n");
      out.write("\r\n");
      out.write("                                cursor:pointer;\r\n");
      out.write("                            }\r\n");
      out.write("\r\n");
      out.write("                            .post-top .post-info{\r\n");
      out.write("                                margin-left:10px;\r\n");
      out.write("                                font-weight: bold;\r\n");
      out.write("                            }\r\n");
      out.write("\r\n");
      out.write("                            .post-top .post-info .name{\r\n");
      out.write("                                cursor:pointer;\r\n");
      out.write("                                font-size:23px;\r\n");
      out.write("                                margin-bottom: 0;\r\n");
      out.write("                            }\r\n");
      out.write("\r\n");
      out.write("                            .post-top .post-info .time{\r\n");
      out.write("                                font-size:14px;\r\n");
      out.write("                                cursor:pointer;\r\n");
      out.write("                            }\r\n");
      out.write("                        </style>\r\n");
      out.write("                        <div class=\"modal-dialog\" role=\"document\">\r\n");
      out.write("                            <div class=\"modal-content\" style=\"width: 700px;\">\r\n");
      out.write("                                <div class=\"modal-header\" style=\"font-size: 15px;\">\r\n");
      out.write("                                    <h5 class=\"modal-title\">Edit Post</h5>                      \r\n");
      out.write("                                </div>\r\n");
      out.write("                                <div class=\"modal-body\">\r\n");
      out.write("                                    <div class=\"post-top\">\r\n");
      out.write("                                        <p style=\"display: none\" id=\"IDpost\"></p>\r\n");
      out.write("                                        <div class=\"dp\" >\r\n");
      out.write("                                            <img id=\"imgUser\" src=\"\" alt=\"\" style=\"width: 100%;\" >\r\n");
      out.write("                                        </div>\r\n");
      out.write("                                        <div class=\"post-info\">\r\n");
      out.write("                                            <p class=\"name\" style=\"color: #003140\" id=\"FullNameU\"></p>\r\n");
      out.write("                                            <span class=\"time\" style=\"color: #70d8ff\" id=\"timePost\"></span>\r\n");
      out.write("\r\n");
      out.write("                                            <select id=\"isPublic\" name = \"privacy\" style=\"color:#626262;\">\r\n");
      out.write("                                                <option style=\"color:#626262; background-color:#cdf1ff;\" value=\"Public\">Public</option>\r\n");
      out.write("                                                <option style=\"color:#626262;background-color:#cdf1ff;\" value=\"Private\">Private</option>\r\n");
      out.write("                                            </select>\r\n");
      out.write("                                        </div>\r\n");
      out.write("                                    </div>\r\n");
      out.write("                                    <div class=\"post-content\" style=\"text-align: center;\">\r\n");
      out.write("                                        <textarea rows =\"2\" style=\"width: 100%; border: none;\" id=\"contentPost\"></textarea>\r\n");
      out.write("                                        <img id=\"imgPost\" src=\"\" style=\" max-width: 660px; max-height: 660px;\"/>\r\n");
      out.write("                                        <br>\r\n");
      out.write("                                        <input type=\"file\" accept=\"image/*,capture=camera\" name=\"photoPost\" id=\"fileInput2\" />\r\n");
      out.write("                                        <button class=\"btn btn-primary\" style=\"font-size: 15px;\" type=\"button\" onclick=\"clearFileInput()\">Clear File Input</button>\r\n");
      out.write("                                    </div>\r\n");
      out.write("                                </div>\r\n");
      out.write("                                <div class=\"modal-footer\">\r\n");
      out.write("                                    <button type=\"submit\" class=\"btn btn-primary\" style=\"font-size: 15px;\" onclick=\"loadUpdate()\">Save changes</button>\r\n");
      out.write("                                    <button type=\"button\" class=\"btn btn-secondary\" data-dismiss=\"modal\" style=\"font-size: 15px;\">Close</button>\r\n");
      out.write("                                </div>\r\n");
      out.write("                            </div>\r\n");
      out.write("                        </div>\r\n");
      out.write("                        <script>\r\n");
      out.write("                            function load(id){\r\n");
      out.write("                                $('#myProfile').modal('show');\r\n");
      out.write("                            }\r\n");
      out.write("                            document.getElementById('fileInput2').addEventListener('change', function (event) {\r\n");
      out.write("                                var file = event.target.files[0];\r\n");
      out.write("\r\n");
      out.write("                                // T?o ??i t??ng FileReader ?? ??c t?p tin\r\n");
      out.write("                                var reader = new FileReader();\r\n");
      out.write("                                reader.onload = function (e) {\r\n");
      out.write("                                    var previewImage = document.getElementById('imgPost');\r\n");
      out.write("                                    previewImage.src = e.target.result;\r\n");
      out.write("                                    previewImage.style = \" max-width:660px; max-height:660px;\";\r\n");
      out.write("                                };\r\n");
      out.write("                                reader.readAsDataURL(file);\r\n");
      out.write("                            });\r\n");
      out.write("                        </script>\r\n");
      out.write("                    </div>\r\n");
      out.write("                </div>\r\n");
      out.write("    <a>Load more</a>\r\n");
      out.write("</div>\r\n");
      out.write("    </body>\r\n");
      out.write("</html>\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
