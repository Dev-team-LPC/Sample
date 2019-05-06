package cc.littlepig.classes;

import com.itextpdf.forms.PdfAcroForm;
import com.itextpdf.io.font.FontConstants;
import com.itextpdf.kernel.font.*;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.property.VerticalAlignment;

public class Footer {
	
	public void addFooter(String DEST, String reportType) throws Exception {
		
		String str = "MICT SETA Progress Report Tool for Internship &WIL Version 1 – 20170126";
		if(reportType.equalsIgnoreCase("site visit")) {
			str = "MICT SETA - Site Visit Report Tool for Learnership &Skills Programme: Version 2 – 2017 02 01";
		}
		
        PdfDocument pdfDoc = new PdfDocument(new PdfReader(DEST), new PdfWriter(DEST.replaceAll("without footer", "with footer")));
        Document doc = new Document(pdfDoc);
        PdfFont font = PdfFontFactory.createFont(FontConstants.HELVETICA_BOLD);
        int n = pdfDoc.getNumberOfPages();
        for (int i = 1; i <= n; i++) {
            doc.showTextAligned(new Paragraph(String.format("Page %s of %s", i, n)), 559, 20, i, TextAlignment.RIGHT, VerticalAlignment.BOTTOM, 0).setFontSize(9).setFont(font);
            doc.showTextAligned(new Paragraph(String.format(str, i, n)), 40, 20, i, TextAlignment.LEFT, VerticalAlignment.BOTTOM, 0).setFontSize(9).setFont(font);
        }
        doc.close();
    }
}
