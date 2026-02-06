# Object Recognition using ORB Features (MATLAB)
**Author:** Arman Azadi
**Institution:** Iran University of Science and Technology (IUST)

## 📌 Project Overview
This project implements a computer vision pipeline to detect, segment, and recognize multiple objects within a single image. Unlike Deep Learning approaches (like YOLO), this system uses **Classical Computer Vision** techniques, making it interpretable and efficient for specific tasks.

The system performs two main steps:
1.  **Object Segmentation:** Detecting where objects are located using morphological operations.
2.  **Object Recognition:** Identifying what the object is by matching features against a reference database.

## 🔬 Methodology

### 1. Segmentation & Detection
* **Preprocessing:** The input image is converted to grayscale and binarized using **Adaptive Thresholding** (`imbinarize`).
* **Morphology:** Applied morphological closing (`imclose`) to fill holes and `bwareaopen` to remove noise/small artifacts.
* **Bounding Boxes:** Used `regionprops` to calculate the Bounding Box for each connected component.

### 2. Feature Extraction & Matching
* **Algorithm:** **ORB (Oriented FAST and Rotated BRIEF)**. ORB is a fast binary descriptor that is rotation-invariant and resistant to noise.
* **Matching Process:**
    1.  For each detected object in the test image, ORB features are extracted.
    2.  These features are matched against every reference image in the `objects/` database.
    3.  The reference image with the highest number of valid feature matches is selected as the label.

## 📂 File Structure
* `main_object_detector.m`: The core script that runs the detection pipeline.
* `objects.zip`: Contains the reference images (labeled ground truth).
* `test_objects.zip`: Contains test images with multiple objects in them.

## 🚀 Usage

### Prerequisites
* MATLAB (Computer Vision Toolbox required for `detectORBFeatures`).

### Setup
1.  Clone the repository.
2.  **Unzip** `objects.zip`. Ensure you have a folder named **`objects`** in the root directory.
3.  **Unzip** `test_objects.zip`. Ensure you have a folder named **`test_objects`**.

### Running the Detector
1.  Open `main_object_detector.m`.
2.  Update the line reading the test image to point to one of your test files:
    ```matlab
    test_img = imread('test_objects/your_test_image.jpg');
    ```
3.  Run the script.
4.  The output will be the test image with **Bounding Boxes** and **Labels** drawn around the recognized objects.

## 📊 Results
The system successfully segments objects and classifies them by matching keypoints.
*(See `Technical_Report.docx` for detailed process flow and detection examples.)*
