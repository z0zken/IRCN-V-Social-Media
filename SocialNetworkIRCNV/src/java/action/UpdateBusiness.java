/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package action;

import controller.Text;
import dao.BusinessDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Business;

/**
 *
 * @author van12
 */
@WebServlet(name = "UpdateBusiness", urlPatterns = {"/UpdateBusiness"})
public class UpdateBusiness extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String status = "";
        String type = request.getParameter("type");
        BusinessDAO businessDAO = new BusinessDAO();
        if (type.equalsIgnoreCase("pay")) {
             String BID = request.getParameter("BID");
             double price= Double.parseDouble(request.getParameter("priceTest"));
             Business business= businessDAO.getBusinessByBusinessID(BID);
             businessDAO.PayBudget(BID, business.getBudget() + price);
        } else {
            Text text = new Text();
            String BID = request.getParameter("BID");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String intro = request.getParameter("intro");
            try {
                Business business = businessDAO.getBusinessByBusinessID(BID);
                business.setBrandName(text.changeUTF8(name));
                business.setAddress(text.changeUTF8(address));
                business.setMail(text.changeUTF8(email));
                business.setPhoneNumber(text.changeUTF8(phone));
                business.setIntro(text.changeUTF8(intro));

                businessDAO.updateInfor(business);

                status = "true";
            } catch (Exception e) {
                e.printStackTrace();
                status = "null";
            }
        }
        //Business business = new Business("", id, name, address, mail, phone, "", intro, 0, "", 0, "");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println(status);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
