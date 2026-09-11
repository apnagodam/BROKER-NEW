import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:flutter/material.dart';

class ProductHelper {
  /// Cleans the commodity name by stripping backend-appended district, warehouse,
  /// stack number, or delivery days that appear in parentheses.
  static String cleanCommodityName(String? commodity, [String? districtOrWarehouse]) {
    if (commodity == null || commodity.trim().isEmpty) return '';
    String clean = commodity.trim();

    // If district or warehouse is provided and clean contains it inside parens
    if (districtOrWarehouse != null && districtOrWarehouse.trim().isNotEmpty) {
      final dw = districtOrWarehouse.trim();
      if (clean.endsWith('($dw)')) {
        clean = clean.substring(0, clean.length - (dw.length + 2)).trim();
      } else if (clean.contains('($dw)')) {
        clean = clean.replaceAll('($dw)', '').trim();
      } else if (clean.contains(dw)) {
        clean = clean.replaceAll(dw, '').trim();
        clean = clean.replaceAll(RegExp(r'\(\s*\)'), '').trim();
      }
    }

    // Check for any outer trailing parentheses containing warehouse, stack, delivery, factory, etc.
    final openParenIdx = clean.indexOf('(');
    final closeParenIdx = clean.lastIndexOf(')');
    if (openParenIdx != -1 && closeParenIdx == clean.length - 1 && openParenIdx > 0) {
      final inside = clean.substring(openParenIdx + 1, closeParenIdx).trim();
      final insideLower = inside.toLowerCase();
      final before = clean.substring(0, openParenIdx).trim();

      // Check if inside is a repetition of the before text, e.g. "Barley (Barley)"
      final bool isRepeat = insideLower == before.toLowerCase();

      // Check if inside contains warehouse / stack / delivery / factory indicators
      final bool containsLocationOrDeliveryInfo =
          insideLower.contains('warehouse') ||
          insideLower.contains('वेयरहाउस') ||
          insideLower.contains('delivery') ||
          insideLower.contains('डिलीवरी') ||
          insideLower.contains('stack') ||
          insideLower.contains('स्टैक') ||
          insideLower.contains('factory') ||
          insideLower.contains('days') ||
          insideLower.contains('दिन') ||
          (districtOrWarehouse != null &&
              districtOrWarehouse.trim().isNotEmpty &&
              insideLower.contains(
                  districtOrWarehouse.trim().split(RegExp(r'[, -]')).first.toLowerCase()));

      if (isRepeat || containsLocationOrDeliveryInfo) {
        clean = before;
      }
    }

    // Clean any trailing whitespace or empty parentheses
    clean = clean.replaceAll(RegExp(r'\s*\(\s*\)$'), '').trim();
    return clean;
  }

  /// Determines whether the product is a factory delivery or warehouse delivery.
  /// SBT type 2 = Factory, SBT type 1 = Warehouse.
  static bool isFactoryDelivery(dynamic sbtType, [String? text]) {
    final typeStr = sbtType?.toString().trim();
    if (typeStr == '2') return true;
    if (typeStr == '1') return false;

    if (text != null && text.isNotEmpty) {
      final lower = text.toLowerCase();
      if (lower.contains('factory') || lower.contains('कारखाना') || lower.contains('फैक्ट्री')) {
        return true;
      }
    }
    return false;
  }

  /// Border color: Orange for Factory (#F25822), Green for Warehouse (#2E7D32).
  static Color deliveryBorderColor(bool isFactory) {
    return isFactory ? const Color(0xFFF25822) : const Color(0xFF2E7D32);
  }

  /// Formats the image URL for commodity or stack images.
  /// Prepends the base URL if the path is relative.
  static String? formatImageUrl(dynamic image, [dynamic path]) {
    if (image == null || image.toString().trim().isEmpty) return null;
    final imgStr = image.toString().trim();
    if (imgStr.startsWith('http://') || imgStr.startsWith('https://')) {
      return imgStr;
    }

    final pathStr = (path != null && path.toString().trim().isNotEmpty)
        ? path.toString().trim()
        : '';

    final combined = '$pathStr$imgStr';
    if (combined.startsWith('http://') || combined.startsWith('https://')) {
      return combined;
    }

    final baseUrl = DioClient.baseUrl.endsWith('/')
        ? DioClient.baseUrl.substring(0, DioClient.baseUrl.length - 1)
        : DioClient.baseUrl;

    final relativePath = combined.startsWith('/') ? combined : '/$combined';
    return '$baseUrl$relativePath';
  }

  /// Extracts delivery days from district/location text (e.g. "Delivery Days :- 7" -> "7 Days").
  static String extractDeliveryDays(String? text) {
    if (text == null || text.trim().isEmpty) return '-';
    final match = RegExp(
      r'(?:delivery\s*days?|डिलीवरी\s*दिन)\s*[:=-]+\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      return '${match.group(1)} Days';
    }
    return '-';
  }

  /// Extracts clean location/warehouse/factory name by removing delivery days info.
  static String extractLocation(String? text) {
    if (text == null || text.trim().isEmpty) return '';
    return text
        .replaceAll(
          RegExp(
            r'[, -]*(?:delivery\s*days?|डिलीवरी\s*दिन)\s*[:=-]+\s*\d+.*',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
  }

  /// Formats bid schedule time by extracting date/bid_time and stripping any HTML tags.
  static String formatBidTime(dynamic date, dynamic bidTime) {
    String timeStr = '';
    if (date != null && date.toString().trim().isNotEmpty) {
      timeStr = date.toString().trim();
    } else if (bidTime != null && bidTime.toString().trim().isNotEmpty) {
      timeStr = bidTime.toString().trim();
    }
    if (timeStr.isEmpty) return '-';

    if (timeStr.contains('<')) {
      timeStr = timeStr
          .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' | ')
          .replaceAll(RegExp(r'</?p>', caseSensitive: false), '')
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();
    }

    return timeStr;
  }
}

