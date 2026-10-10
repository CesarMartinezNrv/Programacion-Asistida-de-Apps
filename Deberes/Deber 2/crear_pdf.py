from pathlib import Path
from xml.sax.saxutils import escape
import re, textwrap
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Preformatted, KeepTogether
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from pypdf import PdfReader

base=Path(__file__).parent
web=base/'divisor_cuenta_web'
out=base/'output/pdf/Informe_Deber2.pdf'
out.parent.mkdir(parents=True,exist_ok=True)
pdfmetrics.registerFont(TTFont('Arial','C:/Windows/Fonts/arial.ttf'))
pdfmetrics.registerFont(TTFont('ArialBold','C:/Windows/Fonts/arialbd.ttf'))
pdfmetrics.registerFont(TTFont('Consolas','C:/Windows/Fonts/consola.ttf'))
pdfmetrics.registerFontFamily('Arial',normal='Arial',bold='ArialBold',italic='Arial',boldItalic='ArialBold')
verde=colors.HexColor('#214e3d'); gris=colors.HexColor('#53645a')
styles={
 'body':ParagraphStyle('body',fontName='Arial',fontSize=9.5,leading=13,spaceAfter=6,textColor=colors.HexColor('#243b30')),
 'h1':ParagraphStyle('h1',fontName='ArialBold',fontSize=19,leading=25,spaceBefore=12,spaceAfter=13,textColor=verde,keepWithNext=True),
 'h2':ParagraphStyle('h2',fontName='ArialBold',fontSize=13,leading=18,spaceBefore=14,spaceAfter=8,textColor=verde,keepWithNext=True),
 'h3':ParagraphStyle('h3',fontName='ArialBold',fontSize=10.5,leading=15,spaceBefore=9,spaceAfter=7,textColor=verde,keepWithNext=True),
 'cell':ParagraphStyle('cell',fontName='Arial',fontSize=8,leading=11,textColor=colors.HexColor('#243b30')),
 'head':ParagraphStyle('head',fontName='ArialBold',fontSize=8,leading=11,textColor=colors.white),
 'code':ParagraphStyle('code',fontName='Consolas',fontSize=7.5,leading=10,spaceAfter=8),
}
def texto(s):
    s=s.replace('→','-&gt;').replace('←','&lt;-').replace('—','-').replace('–','-').replace('×','x')
    s=escape(s).replace('&amp;gt;','&gt;').replace('&amp;lt;','&lt;')
    s=re.sub(r'\[([^\]]+)\]\(([^)]+)\)',lambda m:m.group(1)+' ('+m.group(2)+')',s)
    s=re.sub(r'\*\*([^*]+)\*\*',r'<b>\1</b>',s)
    s=re.sub(r'`([^`]+)`',r'<font name="Consolas">\1</font>',s)
    return s

story=[]
def tabla(rows):
    n=len(rows[0]); ancho=487
    if n==4 and rows[0][0]=='ID': widths=[ancho*.07,ancho*.35,ancho*.35,ancho*.23]
    elif n==4 and 'spec' in rows[0][0]: widths=[ancho*.50,ancho*.14,ancho*.10,ancho*.26]
    elif n==4 and rows[0][0]=='Función': widths=[ancho*.19,ancho*.32,ancho*.20,ancho*.29]
    elif n==4: widths=[ancho*.32,ancho*.32,ancho*.16,ancho*.20]
    elif n==5: widths=[ancho*.18,ancho*.30,ancho*.21,ancho*.21,ancho*.10]
    elif n==3: widths=[ancho*.52,ancho*.24,ancho*.24]
    else: widths=[ancho/n]*n
    cells=[[Paragraph(texto(s),styles['head' if i==0 else 'cell']) for s in row] for i,row in enumerate(rows)]
    t=Table(cells,colWidths=widths,repeatRows=1,hAlign='LEFT',splitByRow=1)
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,0),verde),('VALIGN',(0,0),(-1,-1),'TOP'),
        ('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.HexColor('#f4f7f0'),colors.white]),
        ('LINEBELOW',(0,0),(-1,0),.6,verde),('LINEBELOW',(0,1),(-1,-1),.3,colors.HexColor('#dce5da')),
        ('LEFTPADDING',(0,0),(-1,-1),7),('RIGHTPADDING',(0,0),(-1,-1),7),
        ('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6),
    ]))
    story.extend([t,Spacer(1,9)])

def markdown(md):
    lines=md.splitlines(); i=0
    while i<len(lines):
        line=lines[i].strip()
        if not line: i+=1; continue
        if line.startswith('```'):
            i+=1; code=[]
            while i<len(lines) and not lines[i].startswith('```'):
                code.extend(textwrap.wrap(lines[i],85,replace_whitespace=False,drop_whitespace=False) or ['']); i+=1
            story.append(Preformatted('\n'.join(code),styles['code']));i+=1;continue
        if line.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].strip().startswith('|'):
                row=[s.strip() for s in lines[i].strip().strip('|').split('|')]
                if not all(re.fullmatch(r':?-+:?',s) for s in row): rows.append(row)
                i+=1
            tabla(rows);continue
        if line.startswith('#'):
            level=len(line)-len(line.lstrip('#'))
            story.append(Paragraph(texto(line[level:].strip()),styles['h'+str(min(level,3))]));i+=1;continue
        par=[line];i+=1
        while i<len(lines) and lines[i].strip() and not lines[i].lstrip().startswith(('#','|','```','- ')) and not re.match(r'\d+\.\s',lines[i].strip()):
            par.append(lines[i].strip());i+=1
        contenido=' '.join(par)
        if contenido.startswith('- '): contenido='• '+contenido[2:]
        story.append(Paragraph(texto(contenido),styles['body']))

markdown((web/'respuestas.md').read_text(encoding='utf8').split('## Salidas completas relevantes')[0])

def decorar(c,doc):
    c.saveState(); ancho,alto=A4
    c.setStrokeColor(colors.HexColor('#dce5da'));c.line(54,alto-37,ancho-54,alto-37)
    c.setFont('Arial',8);c.setFillColor(gris)
    c.drawString(54,alto-29,'DEBER 2  |  SDD - Flutter a React')
    c.drawString(54,27,'USFQ · Programación Asistida de Aplicaciones')
    c.drawRightString(ancho-54,27,str(doc.page));c.restoreState()
doc=SimpleDocTemplate(str(out),pagesize=A4,leftMargin=54,rightMargin=54,topMargin=52,bottomMargin=47,title='Deber 2 - Migración SDD Flutter a React',author='César Martínez; preparado con Codex')
doc.build(story,onFirstPage=decorar,onLaterPages=decorar)
reader=PdfReader(out)
print(f'PDF: {out}, {len(reader.pages)} páginas')
assert all(p.extract_text().strip() for p in reader.pages)
for termino in ['27.50','Monto inválido','100%','40/54','9.83','10.15']:
    assert termino in '\n'.join(p.extract_text() for p in reader.pages),termino
