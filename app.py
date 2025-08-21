#!/usr/bin/env python3
"""
EVA Report Generator Web Interface
==================================
Flask web application for uploading MDF files and generating EVA reports
"""

from flask import Flask, render_template, request, send_file, jsonify
import os
from werkzeug.utils import secure_filename
from datetime import datetime
import traceback

# Import the EVA report generator
from generate_eva_report_exact_template import EVAReportGeneratorExactTemplate

app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = 'uploads'
REPORTS_FOLDER = 'eva_reports'
ALLOWED_EXTENSIONS = {'mdf'}

# Create directories if they don't exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(REPORTS_FOLDER, exist_ok=True)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 500 * 1024 * 1024  # 500MB max file size

def allowed_file(filename):
    """Check if file extension is allowed."""
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    """Main page with file upload form."""
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    """Handle file upload and report generation."""
    try:
        # Check if file was uploaded
        if 'mdf_file' not in request.files:
            return jsonify({
                'success': False,
                'message': 'No file selected'
            }), 400
        
        file = request.files['mdf_file']
        if file.filename == '':
            return jsonify({
                'success': False,
                'message': 'No file selected'
            }), 400
        
        # Check file extension
        if not allowed_file(file.filename):
            return jsonify({
                'success': False,
                'message': 'Invalid file type. Only MDF files are allowed.'
            }), 400
        
        # Get form parameters (use defaults since UI no longer provides these)
        sweet_version = '500'  # Default to SWEET 500
        myf_config = 'all'    # Default to all configurations
        
        # Save uploaded file
        filename = secure_filename(file.filename)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_filename = f"{timestamp}_{filename}"
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], safe_filename)
        
        # Ensure upload directory exists
        os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
        
        file.save(file_path)
        
        # Verify file was saved successfully
        if not os.path.exists(file_path):
            return jsonify({
                'success': False,
                'message': 'Failed to save uploaded file'
            }), 500
        
        print(f"File uploaded successfully: {file_path}")
        
        # Generate report using the existing EVA report generator
        try:
            generator = EVAReportGeneratorExactTemplate()
            report_path = generator.run_analysis(file_path, sweet_version, myf_config)
            
            # Verify report was generated
            if not os.path.exists(report_path):
                return jsonify({
                    'success': False,
                    'message': 'Report generation failed - output file not found'
                }), 500
            
            # Get relative path for download
            report_filename = os.path.basename(report_path)
            
            print(f"Report generated successfully: {report_path}")
            
            # Return success response with report info
            return jsonify({
                'success': True,
                'message': 'Report generated successfully!',
                'report_filename': report_filename,
                'report_path': report_path,
                'uploaded_file': filename
            })
            
        except Exception as report_error:
            error_msg = f"Error during report generation: {str(report_error)}"
            print(f"REPORT GENERATION ERROR: {error_msg}")
            print(traceback.format_exc())
            return jsonify({
                'success': False,
                'message': error_msg
            }), 500
        
    except Exception as e:
        error_msg = f"Error during file upload: {str(e)}"
        print(f"UPLOAD ERROR: {error_msg}")
        print(traceback.format_exc())
        return jsonify({
            'success': False,
            'message': error_msg
        }), 500

@app.route('/download/<filename>')
def download_report(filename):
    """Download generated report."""
    try:
        # Security check - ensure filename is safe
        if not filename or '..' in filename or '/' in filename:
            return jsonify({
                'success': False,
                'message': 'Invalid filename'
            }), 400
        
        file_path = os.path.join(REPORTS_FOLDER, filename)
        if os.path.exists(file_path):
            try:
                return send_file(file_path, as_attachment=True)
            except Exception as send_error:
                print(f"Error sending file: {send_error}")
                return jsonify({
                    'success': False,
                    'message': 'Error sending file'
                }), 500
        else:
            return jsonify({
                'success': False,
                'message': 'Report file not found'
            }), 404
    except Exception as e:
        print(f"Download error: {e}")
        return jsonify({
            'success': False,
            'message': f'Error downloading file: {str(e)}'
        }), 500

@app.route('/view/<filename>')
def view_report(filename):
    """View generated report in browser."""
    try:
        # Security check - ensure filename is safe
        if not filename or '..' in filename or '/' in filename:
            return jsonify({
                'success': False,
                'message': 'Invalid filename'
            }), 400
        
        file_path = os.path.join(REPORTS_FOLDER, filename)
        if os.path.exists(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                return content
            except UnicodeDecodeError:
                # Try with different encoding if UTF-8 fails
                try:
                    with open(file_path, 'r', encoding='latin-1') as f:
                        content = f.read()
                    return content
                except Exception as encoding_error:
                    print(f"Encoding error: {encoding_error}")
                    return jsonify({
                        'success': False,
                        'message': 'Error reading file encoding'
                    }), 500
            except Exception as read_error:
                print(f"File read error: {read_error}")
                return jsonify({
                    'success': False,
                    'message': 'Error reading file'
                }), 500
        else:
            return jsonify({
                'success': False,
                'message': 'Report file not found'
            }), 404
    except Exception as e:
        print(f"View error: {e}")
        return jsonify({
            'success': False,
            'message': f'Error viewing report: {str(e)}'
        }), 500

@app.route('/status')
def status():
    """Check application status and show basic info."""
    try:
        upload_count = len(os.listdir(UPLOAD_FOLDER)) if os.path.exists(UPLOAD_FOLDER) else 0
        report_count = len([f for f in os.listdir(REPORTS_FOLDER) if f.endswith('.html')]) if os.path.exists(REPORTS_FOLDER) else 0
        
        return jsonify({
            'status': 'running',
            'upload_folder': UPLOAD_FOLDER,
            'reports_folder': REPORTS_FOLDER,
            'uploaded_files': upload_count,
            'generated_reports': report_count,
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'error': str(e)
        }), 500

if __name__ == '__main__':
    print("Starting EVA Report Generator Web Interface...")
    print(f"Upload folder: {UPLOAD_FOLDER}")
    print(f"Reports folder: {REPORTS_FOLDER}")
    print("Open your browser and go to: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)
