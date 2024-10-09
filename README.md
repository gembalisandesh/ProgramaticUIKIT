# ProgramaticUIKIT

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
  - [Models](#models)
  - [Data Managers](#data-managers)
  - [ViewModels](#viewmodels)
  - [View Controllers](#view-controllers)
- [Data Model](#data-model)
- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Overview

ProgramaticUIKIT is an iOS application designed to manage and filter data related to companies, accounts, brands, and locations. The application utilizes a programmatic approach to UI development, leveraging Swift and UIKit to create a responsive and user-friendly interface.

## Features

- **Company Selection**: Users can select a company from a list, which dynamically updates the available filtering options.
- **Advanced Filtering**: Filter data based on account numbers, brands, and locations.
- **Dynamic Data Retrieval**: Retrieve and decode data from structured JSON format.
- **Programmatic UI**: All UI components are created programmatically for maximum flexibility.
- **Reusable Components**: Utilizes reusable collection views and table views for efficient data display.

## Architecture

The application follows a structured architecture with the following key components:

### Models
- `Welcome`
- `FilterDatum`
- `Hierarchy`
- `BrandNameList`
- `LocationNameList`
- `MerchantNumber`

### Data Managers
- `FilterDataManager`: Loads and manages filter data.
- `MemberIdDataManager`: Retrieves member IDs based on selected filters.

### ViewModels
- `CompanySelectionViewModel`: Manages company selection logic and member ID retrieval.
- `FilterViewModel`: Handles filtering logic based on user selections.

### View Controllers
- `CompanySelectionViewController`: Displays company selection interface.
- `FilterViewController`: Provides filtering interface for various criteria.
- `SelectionViewController`: Reusable controller for multiple-option selection.

## Data Model

The application uses a hierarchical data model to represent companies, accounts, brands, locations, and merchant information. Here's an overview of the main structures:

```swift
struct Welcome: Codable {
    var status, message, errorCode: String
    var filterData: [FilterDatum]
}

struct FilterDatum: Codable {
    var cif: String
    var companyName: String
    var accountList, brandList, locationList: [String]
    var hierarchy: [Hierarchy]
}

struct Hierarchy: Codable {
    var accountNumber: String
    var brandNameList: [BrandNameList]
}

struct BrandNameList: Codable {
    var brandName: String
    var locationNameList: [LocationNameList]
}

struct LocationNameList: Codable {
    var locationName: String
    var merchantNumber: [MerchantNumber]
}

struct MerchantNumber: Codable {
    var mid: String
    var outletNumber: [String]
}
```

This model structure allows for efficient representation and filtering of data across multiple levels of the business hierarchy.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/gembalisandesh/ProgramaticUIKIT.git
   ```
2. Open the project in Xcode:
   ```
   cd ProgramaticUIKIT
   open ProgramaticUIKIT.xcodeproj
   ```
3. Build and run the project on your preferred iOS simulator or device.

## Usage

1. **Initial Setup**: The application loads filter data from a JSON string on launch.
2. **Company Selection**: Select a company to update available filtering options.
3. **Apply Filters**: Choose filters for account numbers, brands, and locations.
4. **View Results**: Filtered member IDs are displayed in a table view.

## Dependencies

- Swift 5.0+
- UIKit

## Contributing

Contributions to ProgramaticUIKIT are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch: `git checkout -b feature-branch-name`
3. Make your changes and commit them: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature-branch-name`
5. Submit a pull request
