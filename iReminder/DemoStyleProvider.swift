//
//  DemoStyleProvider.swift
//  Keyboard
//

import KeyboardKit
import SwiftUI

/**
 This demo-specific provider inherits the standard one, then
 makes the rocket button font larger.
 
 There's a bunch of disabled code that you can enable to see
 how the style of the keyboard changes.
 */
class DemoStyleProvider: StandardKeyboardStyleProvider {
    
  
    

}

private extension KeyboardAction {
    
    var isRocket: Bool {
        switch self {
        case .character(let char): char == "🙂"
        default: false
        }
    }
}
extension KeyboardViewController {
    class EmojiKeyboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        var emojiSelectedHandler: ((String) -> Void)?
        var emojiCollectionView: UICollectionView!
        var closeButton: UIButton!

        private let emojiData: [String: [(String, ClosedRange<Int>)]] = [
            "😀": [("😀", 0x1F600...0x1F64F)],
            "🐻": [("🐶", 0x1f436...0x1F46F)],
            "🍔": [("🍔", 0x1F330...0x1F37F)],
            "🚗": [("🚗", 0x1F680...0x1F6C0)],
            "⚽": [("⚽", 0x1F3C0...0x1F3FF)],
            "💻": [("💻", 0x1F300...0x1F5FF)],
            "🔣": [("🔣", 0x1F300...0x1F5FF)],
           // "🇮🇳": [("🇺🇸", 0x1F1E6...0x1F1FF)],
            "❤️": [("❤️", 0x2764...0x27BF)] // Range covering all heart emojis
        ]



        override func viewDidLoad() {
            super.viewDidLoad()

            setupEmojiCollectionView()
            setupCloseButton()
            setupSectionButtons()
        }

        func setupEmojiCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 40, height: 40)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 80, right: 16)

            emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.backgroundColor = .systemBackground
            emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
            emojiCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
            view.addSubview(emojiCollectionView)
            emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emojiCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                emojiCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

        func setupCloseButton() {
            closeButton = UIButton(type: .system)
            closeButton.setTitle("Close", for: .normal)
            closeButton.addTarget(self, action: #selector(closeEmojiKeyboard), for: .touchUpInside)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(closeButton)
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
                closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        func setupSectionButtons() {

            let buttonHeight: CGFloat = 40

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(stackView)

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])

            var index = 0
            for sectionTitle in emojiData.keys {
                let button = UIButton(type: .system)
                button.setTitle(sectionTitle, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                index += 1
            }
        }

        @objc func sectionButtonTapped(_ sender: UIButton) {
            emojiCollectionView.scrollToItem(at: IndexPath(item: 0, section: sender.tag), at: .top, animated: true)
        }

        @objc func closeEmojiKeyboard() {
            dismiss(animated: true, completion: nil)
        }

        // UICollectionViewDataSource methods
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return emojiData.keys.count
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let sectionData = Array(emojiData.values)[section]
            return sectionData.reduce(0) { $0 + $1.1.count }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.layer.cornerRadius = 8

            let sectionData = Array(emojiData.values)[indexPath.section]
            var currentIndex = 0
            for (_, range) in sectionData {
                if indexPath.item >= currentIndex && indexPath.item < currentIndex + range.count {
                    let unicodeScalarValue = range.lowerBound + indexPath.item - currentIndex
                    let emoji = String(UnicodeScalar(unicodeScalarValue)!)

                    if let emojiLabel = cell.contentView.subviews.first as? UILabel {
                        emojiLabel.text = emoji
                    } else {
                        let emojiLabel = UILabel()
                        emojiLabel.text = emoji
                        emojiLabel.font = UIFont.preferredFont(forTextStyle: .title1)
                        emojiLabel.adjustsFontForContentSizeCategory = true
                        emojiLabel.textAlignment = .center
                        cell.contentView.addSubview(emojiLabel)
                        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            emojiLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                            emojiLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                        ])
                    }
                    break
                } else {
                    currentIndex += range.count
                }
            }

            return cell
        }

        // UICollectionViewDelegate methods
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let sectionData = Array(emojiData.values)[indexPath.section]
            var currentIndex = 0
            for (_, range) in sectionData {
                if indexPath.item >= currentIndex && indexPath.item < currentIndex + range.count {
                    let unicodeScalarValue = range.lowerBound + indexPath.item - currentIndex
                    let emoji = String(UnicodeScalar(unicodeScalarValue)!)
                    emojiSelectedHandler?(emoji)
                    break
                } else {
                    currentIndex += range.count
                }
            }
        }

        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath)
            if let label = headerView.subviews.first as? UILabel {
                label.text = Array(emojiData.keys)[indexPath.section]
            } else {
                let label = UILabel()
                label.text = Array(emojiData.keys)[indexPath.section]
                label.font = UIFont.boldSystemFont(ofSize: 20)
                headerView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                    label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
                ])
            }
            return headerView
        }
    }
    
    func presentEmojiKeyboard() {
            let emojiKeyboardViewController = EmojiKeyboardViewController()
            emojiKeyboardViewController.emojiSelectedHandler = { [weak self] emoji in
                self?.textDocumentProxy.insertText(emoji)
            }

            emojiKeyboardViewController.modalPresentationStyle = .popover
            emojiKeyboardViewController.popoverPresentationController?.sourceView = view
            emojiKeyboardViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            emojiKeyboardViewController.popoverPresentationController?.permittedArrowDirections = []
            present(emojiKeyboardViewController, animated: true, completion: nil)
        }
}
