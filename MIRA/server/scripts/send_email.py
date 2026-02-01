import smtplib
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# --- CONFIGURATION ---
# For a custom domain (e.g., no-reply@sadeem.app), you need a business email provider.
# Examples:
# - Zoho Mail: smtp.zoho.com (Port 587)
# - Outlook/Office365: smtp.office365.com (Port 587)
# - Gmail (Development): smtp.gmail.com (Port 587)

SMTP_SERVER = "smtp.gmail.com" # Change this to your business email server
SMTP_PORT = 587
SENDER_EMAIL = "your_email@gmail.com" 
SENDER_PASSWORD = "your_app_password" 
# ---------------------

def send_email(recipient, code):
    subject = "Your Sadeem Verification Code"
    body = f"""
    <html>
      <body style="font-family: Arial, sans-serif; color: #333;">
        <div style="text-align: center; padding: 20px;">
          <h2 style="color: #6C63FF;">Welcome to Sadeem!</h2>
          <p>You're almost there. Use the code below to verify your email address:</p>
          <div style="background: #f4f4f4; padding: 15px; border-radius: 8px; display: inline-block; margin: 20px 0;">
            <span style="font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #333;">{code}</span>
          </div>
          <p style="color: #666; font-size: 12px;">This code expires in 3 minutes.</p>
        </div>
      </body>
    </html>
    """

    msg = MIMEMultipart()
    msg['From'] = f"Sadeem Team <{SENDER_EMAIL}>"
    msg['To'] = recipient
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'html'))

    try:
        # Connect to SMTP Server
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        text = msg.as_string()
        server.sendmail(SENDER_EMAIL, recipient, text)
        server.quit()
        print("Email sent successfully")
    except Exception as e:
        print(f"Failed to send email: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python send_email.py <recipient_email> <code>")
        sys.exit(1)
    
    recipient = sys.argv[1]
    code = sys.argv[2]
    send_email(recipient, code)
