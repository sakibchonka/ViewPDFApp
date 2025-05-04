//
//  ProductDataModel.swift
//  ViewPDF
//
//  Created by Mohammed Saqib on 03/05/25.
//

struct Product: Codable {
	let id: String
	let name: String
	let data: [String: CodableValue]?
}

enum CodableValue: Codable {
	case string(String)
	case int(Int)
	case double(Double)

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let double = try? container.decode(Double.self) {
			self = .double(double)
		} else if let int = try? container.decode(Int.self) {
			self = .int(int)
		} else if let string = try? container.decode(String.self) {
			self = .string(string)
		} else {
			throw DecodingError.typeMismatch(CodableValue.self, .init(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let s): try container.encode(s)
		case .int(let i): try container.encode(i)
		case .double(let d): try container.encode(d)
		}
	}
}

