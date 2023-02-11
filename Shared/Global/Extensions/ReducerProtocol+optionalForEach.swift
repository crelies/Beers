//
//  ReducerProtocol+optionalForEach.swift
//  Beers
//
//  Created by Christian Elies on 11/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import ComposableArchitecture

extension ReducerProtocol {
    @inlinable
    public func optionalForEach<ElementState, ElementAction, ID: Hashable, Element: ReducerProtocol>(
      _ toElementsState: WritableKeyPath<State, IdentifiedArray<ID, ElementState>?>,
      action toElementAction: CasePath<Action, (ID, ElementAction)>,
      @ReducerBuilder<ElementState, ElementAction> element: () -> Element
    ) -> some ReducerProtocol<State, Action>
    where ElementState == Element.State, ElementAction == Element.Action {
        EmptyReducer()
            .ifLet(toElementsState, action: .self) {
                EmptyReducer()
                    .forEach(\.self, action: toElementAction, element: element)
            }
    }
}
